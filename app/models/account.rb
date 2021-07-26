# frozen_string_literal: true

class Account < ApplicationRecord
  ADMIN_ROLE = 'ADMIN'
  # Include default devise modules
  # devise :rememberable, :omniauthable
  # devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable
  devise :omniauthable

  validates_presence_of :netid
  validates_uniqueness_of :netid
  delegate :to_s, to: :netid
  delegate :uid, to: :netid

  def self.roles(netid)
    roles = []
    if netid
      roles.append('LOGGEDIN')
      user = Account.find_by_netid(netid)
      roles.append('ADMIN') if user
    else
      roles = ['ANONYMOUS']
    end
    roles
  end

  def self.from_cas(access_token)
    find_by(provider: access_token.provider, netid: access_token.uid)
  end

  def email
    "#{netid}@princeton.edu"
  end
end
