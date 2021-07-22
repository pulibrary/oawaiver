# frozen_string_literal: true

class Account < ActiveRecord::Base
  ADMIN_ROLE = 'ADMIN'

  validates_presence_of :netid
  validates_uniqueness_of :netid

  delegate :to_s, to: :netid

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
end
