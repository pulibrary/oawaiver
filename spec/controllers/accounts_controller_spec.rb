# frozen_string_literal: true

require "rails_helper"

RSpec.describe AccountsController, type: :controller do
  let(:valid_attributes) do
    {
      netid: Faker::Name.last_name
    }
  end
  let(:invalid_attributes) do
    {
      invalid: "invalid"
    }
  end
  let(:admin_user) { FactoryBot.create(:admin_user) }

  describe "POST /create" do
    context "with valid parameters" do
      it "fails without authentication" do
        post :create, params: { account: valid_attributes }

        expect(response).to have_http_status(:redirect)
        expect(response.location).to eq(new_account_session_url)
      end

      context "with an existing CAS account for an admin." do
        let(:params) do
          {
            account: valid_attributes
          }
        end

        before do
          sign_in(admin_user)
        end

        it "creates a new User" do
          expect(Account.count).to eq(1)
          post(:create, params: params)
          expect(Account.count).to eq(2)
        end

        it "assigns a newly created account as @account" do
          post(:create, params: params)

          expect(assigns(:account)).to be_a(Account)
          expect(assigns(:account)).to be_persisted
        end

        it "redirects to the manage_url" do
          post :create, params: { account: valid_attributes }

          expect(response).to redirect_to(manage_url)
        end
      end
    end

    context "with invalid parameters" do
      context "with an existing CAS account for an admin." do
        before do
          sign_in(admin_user)
        end

        it "assigns a newly created and unsaved account as @account" do
          post :create, params: { account: invalid_attributes }
          expect(assigns(:account)).to be_a_new(Account)
        end

        it "redirects to the manage_url" do
          post :create, params: { account: invalid_attributes }
          expect(response).to redirect_to(manage_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    before do
      delete(:destroy, params: params)
    end

    context "with an existing CAS account for an admin." do
      let(:account) { Account.create(valid_attributes) }
      let(:params) do
        {
          id: account.id
        }
      end

      before do
        sign_in(admin_user)
      end

      it "redirects to the manage_url" do
        delete(:destroy, params: params)

        expect(response).to redirect_to(manage_url)
      end
    end
  end
end
