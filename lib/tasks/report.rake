# frozen_string_literal: true

require "optparse"

namespace :report do
  desc "List recent waiver requests"
  task :recent, [:max] => :environment do |_t, args|
    args.with_defaults({ max: "25" })
    max_num = args[:max].to_i

    puts %w[created_at requester_email name title journal].join("\t")
    WaiverInfo.all.limit(max_num).each do |w|
      puts [w.created_at, w.requester_email, "#{w.author_last_name},#{w.author_first_name}", w.title, w.journal].join("\t")
    end
  end

  namespace :waivers do
    def legacy_with_requested_by_faculty_emplid(w)
      return false unless w.notes

      faculty = nil
      if w .notes
        uid = w.notes.gsub(/.*requested by user with emplId /m, "").split("\n")[0]
        uid = uid.gsub(/[' ]*/, "")
        faculty = Employee.find_by(unique_id: uid)
      end
      !faculty.nil?
    end

    desc "count waivers with various properties"
    task count_legacy_with_props: :environment do |_t, _args|
      author_status_list = WaiverInfo.select(:author_status).uniq.collect(&:author_status)
      legacy_waivers = WaiverInfo.where(requester: "provost")
      puts "Total Legacy Waivers: #{legacy_waivers.count}"
      wemplid = legacy_waivers.where("notes LIKE ?", "%requested by user with emplId%")
      author_status_list.each do |st|
        puts "\nLegacy Waivers author_status=#{st} Total: #{legacy_waivers.where(author_status: st).count}"
        requester_emplid = wemplid.where(author_status: st)
        puts "Legacy Waivers author_status=#{st} has note 'requested by user with emplId..': #{requester_emplid.count}"
        requester_emplid_is_fac = requester_emplid.select { |w| legacy_with_requested_by_faculty_emplid(w) }
        puts "Legacy Waivers author_status=#{st} has note 'requested by user with emplId <faculty_id>': #{requester_emplid_is_fac.length}"
        requester_emplid_is_fac.each do |w|
          puts [w.id, w.author_email, w.requester_email, w.journal, w.title].join("\t")
        end
      end
    end

    desc "print_faculty_waivers"
    task print_faculty_waivers: :environment do |_t, _args|
      st = "faculty"
      ws = WaiverInfo.where(author_status: st)
      ws.each do |w|
        puts [w.id, w.author_email, w.requester_email, w.journal, w.title].join("\t")
      end
    end
  end
end
