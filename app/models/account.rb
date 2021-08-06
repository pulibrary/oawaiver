# frozen_string_literal: true

class Account < ApplicationRecord
  ADMIN_ROLE = "ADMIN"
  AUTHENTICATED_ROLE = "LOGGEDIN"
  ANONYMOUS_ROLE = "ANONYMOUS"

  validates_presence_of :netid
  validates_uniqueness_of :netid
  delegate :to_s, to: :netid
  delegate :uid, to: :netid
  devise(:omniauthable)

  def self.roles(netid)
    persisted = Account.find_by_netid(netid)
    return persisted.roles if persisted

    [ANONYMOUS_ROLE]
  end

  def self.from_omniauth(access_token)
    models = where(provider: access_token.provider, netid: access_token.uid)
    models.first_or_create do |account|
      account.netid = access_token.uid
      account.provider = access_token.provider
      account.role = AUTHENTICATED_ROLE
    end
  end

  def admin?
    role == ADMIN_ROLE
  end

  def roles
    values = if netid
               [AUTHENTICATED_ROLE]
             else
               [ANONYMOUS_ROLE]
             end

    values << ADMIN_ROLE if admin?
    values
  end

  def authenticated?
    roles.include?(AUTHENTICATED_ROLE)
  end

  def email
    "#{netid}@princeton.edu"
  end

  def self.from_cas(access_token)
    find_by(provider: access_token.provider, netid: access_token.uid)
  end

  def admin?
    role == ADMIN_ROLE
  end

  def roles
    values = if netid
               [AUTHENTICATED_ROLE]
             else
               [ANONYMOUS_ROLE]
             end

    values << ADMIN_ROLE if admin?
    values
  end

  def authenticated?
    roles.include?(AUTHENTICATED_ROLE)
  end

  def email
    "#{netid}@princeton.edu"
  end
end
