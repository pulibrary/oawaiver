class Account < ActiveRecord::Base

  validates_presence_of :netid
  validates_uniqueness_of :netid

  def to_s
    return "#{netid}"
  end

  def self.roles(netid)
    roles = [];
    if (netid) then
      roles.append("LOGGEDIN");
      user = Account.find_by_netid(netid);
      if (user) then
        roles.append("ADMIN");
      end
    else
      roles = ["ANONYMOUS"];
    end
    return roles;
  end
end
