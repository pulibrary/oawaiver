# frozen_string_literal: true

require "rails_helper"

describe "routes for Widgets", type: :routing do
  it "routes /accounts/auth/cas to the Accounts::OmniauthCallback#cas" do
    response = get("/accounts/auth/cas")
    expect(response).to route_to(controller: "accounts/omniauth_callbacks", action: "passthru")
  end

  it "routes /sign_out to Devise::Sessions#destroy" do
    response = delete("/sign_out")
    expect(response).to route_to("devise/sessions#destroy")
  end
end
