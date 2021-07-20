require 'optparse'
require 'lumberjack'

namespace :import do
  namespace :authors do

    desc "Upload from csv file, :log #{Lumberjack::Severity::SEVERITY_LABELS}"
    task :csv, [:filename, :log] => :environment do |t, args|
      args.with_defaults({:log => "INFO"});
      loglevel = Lumberjack::Severity::SEVERITY_LABELS.index(args[:log].upcase)
      logger = Lumberjack::Logger.new(device = STDOUT, options = {:level => loglevel})

      filename = args.filename;

      if (not filename) then
        puts "usage: #{t.name}[filename]"
        puts "\tfilename - xls file as exported from HR db"
        puts "\tlog      - #{Lumberjack::Severity::SEVERITY_LABELS}"
        raise "#{t.name}: must provide filename" if not filename
      end

      results = Employee.loadCsv(filename, logger);
      if results[:failed].empty?
        logger.info "Successfully loaded #{results[:loaded]} employee records"
      else
        logger.error "Failed to    read   #{results[:failed].count} record lines"
        results[:failed].each do |line, errors|
          errors.each do |e|
            logger.error "line: #{line}: #{e}";
          end
        end
      end
      exit(results[:failed].length);
    end
  end
end