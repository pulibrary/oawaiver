# frozen_string_literal: true

module Waiver
  module Authentication
    DEFAULT_ALLOWED_IPS = "0.0.0.0"

    def self.allowed_hosts
      @allowed_hosts ||= DEFAULT_ALLOWED_HOSTS
    end

    def self.allowed_hosts=(values)
      @allowed_hosts = values
    end

    def self.set_allowed_ips(values)
      @allowed_hosts = values
    end

    def self.set_authorized_user(session, value)
      session[:cas_user] = value
    end
  end
end
