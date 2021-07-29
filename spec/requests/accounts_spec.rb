# frozen_string_literal: true

require 'rails_helper'

describe AccountsController, type: :request do
  describe "GET /" do
    context 'when authenticated as a valid user' do
      let(:valid_user) { FactoryGirl.create(:admin_account) }

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

  describe "POST /accounts" do
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

      it "creates and persists the new Account Model, and redirects to the management URL" do
        expect(Account.count).to eq(1)
        post(accounts_path, params: params)

        expect(response).to redirect_to(manage_url)
        expect(Account.count).to eq(2)
      end
    end
  end

  describe "DELETE /accounts/:id" do
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
      let(:valid_user) { FactoryGirl.create(:admin_account) }
      let(:account1) { FactoryGirl.create(:account) }
      let(:account1_path) { account_path(id: account1.id) }

      before do
        account1
        sign_in(valid_user)
      end

      it "creates and persists the new Account Model" do
        expect(Account.count).to eq(2)
        delete(account1_path)

        expect(Account.count).to eq(1)
      end
    end
  end
end
