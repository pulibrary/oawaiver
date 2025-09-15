# frozen_string_literal: true

module Accounts
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def cas
      @account = Account.from_omniauth(access_token)

      sign_in_and_redirect(@account, event: :authentication)
      return unless is_navigational_format?

      set_flash_message(:success, :success,
                        kind: "from Princeton Central Authentication Service")
    end

    private

    def access_token
      request.env["omniauth.auth"]
    end
  end
end
