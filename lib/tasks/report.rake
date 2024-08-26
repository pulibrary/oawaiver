# frozen_string_literal: true

require "optparse"

namespace :report do
  desc "Generate a CSV report for Waivers"
  task :waivers, [:path] => :environment do |_t, args|
    path = args.fetch(:path, "./reports/waiver_info_report.csv")
    Rails.logger.info("Generating Waiver report to #{path}...")

    models = WaiverInfo.all
    report = WaiverInfoReport.new(models: models, path: path)

    report.generate
    Rails.logger.info("Generated Waiver report to #{path}.")
  end
end
