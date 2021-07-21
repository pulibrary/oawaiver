init_file = "config/waiver_mail.yml"

begin
  options = YAML.load_file("#{::Rails.root.to_s}/#{init_file}")
  Rails.application.config.waiver_mailer_parameters = options
  WaiverMailer::Bootstrap()
rescue Exception => e
  raise "could not initialize from " + init_file + ": " + e.message
end
