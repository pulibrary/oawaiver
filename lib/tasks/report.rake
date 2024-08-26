# frozen_string_literal: true

require "optparse"

namespace :report do
  desc ""
  task :export, [] => :environment do |_t, args|
    csv = CSV.open("waiver_report.csv", "wb")
    headers = [
      "created_at",
      "updated_at",
      "requester_email",
      "author_first_name",
      "author_last_name",
      "author_status",
      "author_department",
      "author_email",
      "title",
      "journal",
      "journal_issn",
      "notes",
    ]
    csv << headers

    WaiverInfo.all.each do |w|

      row = [
        w.created_at,
        w.updated_at,
        w.requester_email,
        w.author_first_name,
        w.author_last_name,
        w.author_status,
        w.author_department,
        w.author_email,
        w.title,
        w.journal,
        w.journal_issn,
        w.notes,
      ]

      csv << row
    end
  end


end
