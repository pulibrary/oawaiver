# frozen_string_literal: true

namespace :account do
  desc 'create accounts  - separate with " " '
  task :create, [:accounts] => :environment do |_t, args|
    args.with_defaults({})
    args.accounts.split(" ").each do |netid|
      a = Account.create(netid: netid)
      puts "Account.created #{a.netid}"
    end
  end

  desc "delete account"
  task :delete, [:netid] => :environment do |_t, args|
    args.with_defaults({})
    netid = args.netid
    a = nil
    a = Account.find_by(netid: args[:netid]) if netid
    if a
      a.destroy
      puts "deleted #{a.netid}"
    end
  end

  desc "list accounts"
  task list: :environment do |_t|
    Account.all.each do |a|
      puts a.netid
    end
  end
end
