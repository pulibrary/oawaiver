# frozen_string_literal: true
module Accounts
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def cas
      @account = Account.from_omniauth(access_token)

      sign_in_and_redirect(@account, event: :authentication)
      set_flash_message(:success, :success, kind: "from Princeton Central Authentication Service") if is_navigational_format?
    end

    private

    def access_token
      request.env["omniauth.auth"]
    end

    def cas_failure
      set_flash_message!(:alert, :failure, kind: OmniAuth::Utils.camelize("cas"), reason: "Failed to authenticate using the Princeton University CAS. Please contact support for assistance.")
      redirect_to(root_path)
    end
  end
end
