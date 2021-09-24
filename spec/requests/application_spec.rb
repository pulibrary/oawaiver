# frozen_string_literal: true

require "rails_helper"

describe ApplicationController, type: :request do
  describe "GET /sign_in" do
    it "authenticates using the access token" do
      get("/sign_in")

      expect(response.status).to eq(302)
      expect(response).to redirect_to(new_account_session_path)
    end
  end

  describe "GET /login" do
    it "authenticates using the access token" do
      get("/login")

      expect(response.status).to eq(302)
      expect(response).to redirect_to(new_account_session_path)
    end
  end
end
