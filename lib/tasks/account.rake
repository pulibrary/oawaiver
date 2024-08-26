# frozen_string_literal: true

namespace :account do
  desc "list accounts"
  task list: :environment do |_t|
    Account.all.each do |a|
      puts a.netid
    end
  end
end
