# frozen_string_literal: true

require "optparse"

namespace :import do
  namespace :authors do
    desc "Upload from csv file"
    task :csv, %i[filename] => :environment do |t, args|
      filename = args.filename

      unless filename
        puts "usage: #{t.name}[filename]"
        puts "\tfilename - xls file as exported from HR db"
        raise "#{t.name}: must provide filename" unless filename
      end

      results = Employee.loadCsv(filename, Rails.logger)
      if results[:failed].empty?
        Rails.logger.info "Successfully loaded #{results[:loaded]} employee records"
      else
        Rails.logger.error "Failed to    read   #{results[:failed].count} record lines"
        results[:failed].each do |line, errors|
          errors.each do |e|
            Rails.logger.error "line: #{line}: #{e}"
          end
        end
      end
      exit(results[:failed].length)
    end
  end
end
