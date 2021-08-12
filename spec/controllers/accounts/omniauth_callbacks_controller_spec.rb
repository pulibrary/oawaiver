# frozen_string_literal: true

require "rails_helper"

RSpec.describe Accounts::OmniauthCallbacksController do
  before { request.env["devise.mapping"] = Devise.mappings[:account] }

  describe "logging in" do
    before do
      allow(Account).to receive(:from_omniauth) { FactoryBot.create(:account) }

      get(:cas)
    end

    it "redirects to home page with a successful alert" do
      expect(response).to redirect_to(new_account_session_path)
      expect(flash[:success]).to eq("Successfully authenticated from from Princeton Central Authentication Service account.")
    end
  end
end
