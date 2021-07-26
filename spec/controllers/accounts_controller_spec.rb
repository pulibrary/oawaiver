# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  before(:all) do
    # FactoryGirl.build(:admin_user).save
  end

  after(:all) do
    Account.delete_all
  end

  let(:valid_attributes) do
    {
      netid: Faker::Name.last_name
    }
  end

  let(:invalid_attributes) do
    {
      netid: ''
    }
  end

  let(:admin_user) { FactoryGirl.build(:admin_user) }

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'fails without authentication' do
        post :create, params: { account: valid_attributes }

        expect(response).to have_http_status(:redirect)
        expect(response.location.start_with?('https://fed.princeton.edu/cas/login')).to be true
      end

      context 'with an existing CAS account for an admin.' do
        let(:params) do
          {
            account: valid_attributes
          }
        end

        before do
          sign_in(admin_user)
          Waiver::Authentication.set_authorized_user(session, admin_user.netid)

          # expect { post :create, params: params }.to change(Account, :count).by(1)
          post(:create, params: params)
        end

        it 'creates a new User' do
          expect(Account.count).to eq(1)
        end

        it 'assigns a newly created account as @account' do
          # post(:create, params: params)

          expect(assigns(:account)).to be_a(Account)
          expect(assigns(:account)).to be_persisted
        end

        it 'redirects to the manage_url' do
          # post :create, params: { account: valid_attributes }

          expect(response).to redirect_to(manage_url)
        end
      end
    end

    context 'with invalid parameters' do
      context 'with an existing CAS account for an admin.' do
        before do
          Waiver::Authentication.set_authorized_user(session, admin_user.netid)
        end

        it 'assigns a newly created and unsaved account as @account' do
          post :create, params: { account: invalid_attributes }
          expect(assigns(:account)).to be_a_new(Account)
        end

        it 'redirects to the manage_url' do
          post :create, params: { account: invalid_attributes }
          expect(response).to redirect_to(manage_url)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    it 'fail without authentication' do
      delete :destroy, params: { id: 'doesnotmatter' }
      expect(response).to have_http_status(:redirect)
      expect(response.location.start_with?('https://fed.princeton.edu/cas/login')).to be true
    end

    context 'with an existing CAS account for an admin.' do
      before do
        Waiver::Authentication.set_authorized_user(session, admin_user.netid)
      end

      it 'destroys the requested account' do
        account = Account.create! valid_attributes
        expect do
          delete :destroy, params: { id: account.id }
        end.to change(Account, :count).by(-1)
      end

      it 'redirects to the manage_url' do
        account = Account.create! valid_attributes
        delete :destroy, params: { id: account.id }
        expect(response).to redirect_to(manage_url)
      end
    end
  end
end
