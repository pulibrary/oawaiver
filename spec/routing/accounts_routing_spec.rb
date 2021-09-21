# frozen_string_literal: true
require "rails_helper"

describe "routes for Widgets", type: :routing do
  it "routes /accounts/sign_in to the Accounts::OmniauthCallback#cas" do
    response = get("/sign_in")
    expect(response).to route_to("accounts/omniauth_callbacks#cas", provider: :cas)
  end

  it "routes /accounts/login to the Accounts::OmniauthCallback#cas" do
    response = get("/login")
    expect(response).to route_to("accounts/omniauth_callbacks#cas", provider: :cas)
  end

  it "routes /sign_out to Devise::Sessions#destroy" do
    response = delete("/sign_out")
    expect(response).to route_to("devise/sessions#destroy")
  end

  it "routes /logout to Devise::Sessions#destroy" do
    response = delete("/logout")
    expect(response).to route_to("devise/sessions#destroy")
  end
end
