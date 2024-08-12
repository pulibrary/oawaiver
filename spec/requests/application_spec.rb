# frozen_string_literal: true

require "rails_helper"

describe ApplicationController, type: :request do
  describe "GET /sign_in" do
    it "authenticates using the access token" do
      get("/sign_in")

      expect(response.status).to eq(301)
      expect(response).to redirect_to(account_cas_omniauth_authorize_path)
    end
  end

  describe "GET /login" do
    it "authenticates using the access token" do
      get("/sign_in")

      expect(response.status).to eq(301)
      expect(response).to redirect_to(account_cas_omniauth_authorize_path)
    end
  end

  describe "DELETE /logout" do
    let(:valid_user) { FactoryBot.create(:regular_user) }
    let(:auth_hash) do
      {
        provider: "cas",
        uid: valid_user.netid
      }
    end

    before do
      sign_in(valid_user)
      delete("/logout")
    end

    it "destroys the current user session" do
      expect(response.status).to eq(301)
      expect(response).to redirect_to(destroy_account_session_path)
    end
  end
end
