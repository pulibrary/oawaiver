# frozen_string_literal: true

# init_file = "config/waiver_mail.yml"

begin
  # options = YAML.load_file("#{::Rails.root}/#{init_file}")

  waiver_mailer_config_path = Rails.root.join("config", "waiver_mail.yml")
  waiver_mailer_parameters = YAML.load_file(waiver_mailer_config_path)
  Rails.application.config.waiver_mailer_parameters = waiver_mailer_parameters

  WaiverMailer.bootstrap
rescue StandardError => error
  # raise "could not initialize from " + init_file + ": " + e.message
  raise("Failed to initialize the WaiverMailer from the configuration #{waiver_mailer_config_path}: #{error.message}")
end
