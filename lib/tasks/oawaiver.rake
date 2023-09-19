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

  namespace :solr do
    desc "Delete all data models indexed in Solr"
    task delete: [:environment] do
      Sunspot.remove_all
    end

    desc "Optimize the Solr Collection"
    task optimize: [:environment] do
      Sunspot.optimize
    end

    desc "Delete and reindex data models into Solr with optimization"
    task reindex: [:environment] do
      Rake::Task["oawaiver:solr:delete"].invoke
      Rake::Task["sunspot:reindex"].invoke
      Rake::Task["oawaiver:solr:optimize"].invoke
    end
  end
end
