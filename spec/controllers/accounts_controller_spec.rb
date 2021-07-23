# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  before(:all) do
    FactoryGirl.build(:admin_user).save
  end

  after(:all) do
    Account.delete_all
  end

  # minimal set of attributes required to create a valid account
  let(:valid_attributes) do
    return { netid: Faker::Name.last_name }
  end

  # invalid attributes  --> can't create account
  let(:invalid_attributes) do
    return { netid: '' }
  end

  def authenticate_with(user)
    Waiver::Authentication.set_authorized_user(session, FactoryGirl.build(user).netid)
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'fail without authentication' do
        post :create, params: { account: valid_attributes }
        expect(response).to have_http_status(:redirect)
        expect(response.location.start_with?('https://fed.princeton.edu/cas/login')).to be true
      end

      it 'creates a new User' do
        authenticate_with(:admin_user)
        expect do
          post :create, params: { account: valid_attributes }
        end.to change(Account, :count).by(1)
      end

      it 'assigns a newly created account as @account' do
        authenticate_with(:admin_user)
        post :create, params: { account: valid_attributes }
        expect(assigns(:account)).to be_a(Account)
        expect(assigns(:account)).to be_persisted
      end

      it 'redirects to the manage_url' do
        authenticate_with(:admin_user)
        post :create, params: { account: valid_attributes }
        expect(response).to redirect_to(manage_url)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created and unsaved account as @account' do
        authenticate_with(:admin_user)
        post :create, params: { account: invalid_attributes }
        expect(assigns(:account)).to be_a_new(Account)
      end

      it 'redirects to the manage_url' do
        authenticate_with(:admin_user)
        post :create, params: { account: invalid_attributes }
        expect(response).to redirect_to(manage_url)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'fail without authentication' do
      delete :destroy, params: { id: 'doesnotmatter' }
      expect(response).to have_http_status(:redirect)
      expect(response.location.start_with?('https://fed.princeton.edu/cas/login')).to be true
    end

    it 'destroys the requested account' do
      authenticate_with(:admin_user)
      account = Account.create! valid_attributes
      expect do
        delete :destroy, params: { id: account.id }
      end.to change(Account, :count).by(-1)
    end

    it 'redirects to the manage_url' do
      authenticate_with(:admin_user)
      account = Account.create! valid_attributes
      delete :destroy, params: { id: account.id }
      expect(response).to redirect_to(manage_url)
    end
  end
end
