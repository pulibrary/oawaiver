# frozen_string_literal: true
module Accounts
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def cas
      @account = Account.from_cas(netid)

      if @account.nil?
        redirect_to root_path
        flash[:error] = "You are not authorized"
      else
        sign_in_and_redirect @account, event: :authentication

        set_flash_message(:success, :success, kind: "from Princeton Central Authentication Service") if is_navigational_format?
      end
    end

    private

    def netid
      request.env["omniauth.auth"]
    end
  end
end
