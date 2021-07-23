# frozen_string_literal: true

# Application and WaiverInfosControllers include Waiver::Authentication as mixin
#
# The Application Controller uses the get_user method to display the currently
# logged in user
#
# The WaiverInfosController requires the successful completion of the authenticate
# method before all of its actions
#

# Configure CAS client
require 'casclient'
require 'casclient/frameworks/rails/filter'

module Waiver
  # this implementation allows the following requests
  #   A - from IP addresses (as determined by the REMOTE_ADDR header)
  #       listed in @@ALLOWED_IPS
  #     - that use the GET method
  #     - and that request non html formats
  #   B - all other requesters are required to authenticate via
  #       the CAS central authentication
  #
  # if authorized via A - user and user_email are set based on the
  # CAS credentials
  #
  # if authorised via B - user is set to User.first.netid
  # and the email is left empty
  module Authentication
    @@ALLOWED_IPS = '0.0.0.0'

    # Princeton CAS authentication
    CASClient::Frameworks::Rails::Filter.configure(
      cas_base_url: 'https://fed.princeton.edu/cas',
      cas_destination_logout_param_name: 'url'
    )

    # authenticate
    #    via IP filtering for get requests on non html requests
    #    via CASClient otherwise
    # assign @user and @user_email accordingly
    def authenticate
      success = false
      if request.get? && !request.format.html?
        success = @@ALLOWED_IPS.include?(request.env['REMOTE_ADDR'])
        if success
          # just assign the first registered user
          @user = Account.first.netid
          @user_email = ''
        end
      else
        success = CASClient::Frameworks::Rails::Filter.filter(self) unless session[:cas_user]
        get_user_data # set here to play nice with set_authorized_user method
      end
      logger.debug("authenticated #{success} as user='#{@user}'")

      success
    end

    # sets @user and  @user_email if a user is logged in
    def get_user_data
      @user = session[:cas_user]
      @user_email = @user + '@princeton.edu' if @user
    end

    # cleans up session data
    def logout_redirect(destination_url)
      CASClient::Frameworks::Rails::Filter.logout(self, destination_url)
    end

    # used in spec tests
    def self.set_allowed_ips(str)
      old = @@ALLOWED_IPS
      @@ALLOWED_IPS = str
      old
    end

    def self.set_authorized_user(session, str)
      session[:cas_user] = str
    end
  end
end
