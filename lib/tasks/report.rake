# frozen_string_literal: true

require "optparse"

namespace :report do
  desc ""
  task :export, [] => :environment do |_t, args|

    WaiverInfo.all.each do |w|

      row = [
        w.created_at,
        w.requester_email,
        w.author_first_name,
        w.author_last_name,
        w.author_status,
        w.author_department,
        w.author_email,
        w.title,
        w.journal
      ]
    end
  end


end
