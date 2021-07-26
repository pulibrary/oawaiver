# frozen_string_literal: true

module Features
  module SessionHelpers
    include Warden::Test::Helpers

    def login_as(user)
      uid = if user.instance_of?(Account)
              user.netid
            else
              persisted = FactoryGirl.create(:regular_user)
              persisted.netid
            end

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:cas, uid: uid)
      visit(account_cas_omniauth_authorize_path)
      # get(account_cas_omniauth_authorize_path)
    end
  end
end
