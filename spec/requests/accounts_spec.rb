# frozen_string_literal: true

require 'rails_helper'

describe AccountsController, type: :request do
  describe "#index" do
    context 'when authenticated as a valid user' do
      let(:valid_user) { FactoryGirl.create(:regular_user) }

      before do
        login_as(valid_user)
      end

      it "renders the NetID for the authenticated user" do
        get(root_path)

        expect(response.status).to eq(200)
        expect(response).to render_template('layouts/application')
        expect(response.body).to include('Request a Waiver')
        expect(response.body).to include('Review Requests')
      end
    end
  end

  describe "#create" do
    let(:valid_attributes) do
      {
        netid: Faker::Name.last_name
      }
    end
    let(:params) do
      {
        account: valid_attributes
      }
    end

    it "redirects to the CAS authentication endpoint" do
      post(accounts_path, params: params)

      expect(response).to redirect_to(root_path)
    end

    context 'when authenticated as a valid user' do
      let(:valid_user) { FactoryGirl.create(:regular_user) }
      let(:auth_hash) do
        {
          provider: 'cas',
          uid: valid_user.netid
        }
      end

      before do
        sign_in(valid_user)
      end

      it "creates and persists the new Account Model" do
        expect(Account.count).to eq(1)
        post(accounts_path, params: params)

        expect(Account.count).to eq(2)
      end
    end
  end

  describe "#destroy" do
    let(:valid_attributes) do
      {
        netid: Faker::Name.last_name
      }
    end
    let(:params) do
      {
        account: valid_attributes
      }
    end

    it "redirects to the CAS authentication endpoint" do
      post(accounts_path, params: params)

      expect(response).to redirect_to(root_path)
    end

    context 'when authenticated as a valid user' do
      let(:valid_user) { FactoryGirl.create(:regular_user) }
      let(:user1) { FactoryGirl.create(:regular_user) }

      before do
        sign_in(valid_user)
      end

      it "creates and persists the new Account Model" do
        expect(Account.count).to eq(2)
        delete(accounts_path, params: { user: user1 })

        expect(Account.count).to eq(1)
      end
    end
  end
end
