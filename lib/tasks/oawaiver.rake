# frozen_string_literal: true

namespace :oawaiver do
  namespace :accounts do
    desc "Add the administrator role to a user account"
    task :add_admin_role, [:netid] => :environment do |_t, args|
      netid = args[:netid]

      account = Account.find_by(netid: netid)
      raise("Failed to find the user account: #{netid}") unless account

      account.role = Account::ADMIN_ROLE
      account.save
      $stdout.puts("Successfully added the administrator role to the account for #{netid}")
    end

    desc "Remove the administrator role to a user account"
    task :remove_admin_role, [:netid] => :environment do |_t, args|
      netid = args[:netid]

      account = Account.find_by(netid: netid)
      raise("Failed to find the user account: #{netid}") unless account

      account.role = Account::AUTHENTICATED_ROLE
      account.save
      $stdout.puts("Successfully removed the administrator role to the account for #{netid}")
    end
  end
end
