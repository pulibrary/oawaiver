# frozen_string_literal: true

require File.expand_path("boot", __dir__)

require "rails/all"
require_relative "lando_env"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Waiver
  VERSION = "1.0.0"

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    config.load_defaults 8.0
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = "Eastern Time (US & Canada)"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.eager_load_paths << Rails.root.join("extras")

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       view_specs: false,
                       request_specs: true

      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.revision = Waiver::VERSION

    config.after_initialize do
      waiver_mailer_config_path = Rails.root.join("config", "waiver_mail.yml")
      waiver_mailer_parameters = YAML.load_file(waiver_mailer_config_path)
      Rails.application.config.waiver_mailer_parameters = waiver_mailer_parameters

      # require 'pry'
      # binding.pry
      begin
        WaiverMailer.bootstrap
      rescue StandardError => error
        Rails.logger.error(error)
      end
    end
  end
end
