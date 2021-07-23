# frozen_string_literal: true

init_file = 'config/waiver_mail.yml'

begin
  options = YAML.load_file("#{::Rails.root}/#{init_file}")
  Rails.application.config.waiver_mailer_parameters = options
  WaiverMailer::Bootstrap()
rescue StandardError => e
  raise 'could not initialize from ' + init_file + ': ' + e.message
end
