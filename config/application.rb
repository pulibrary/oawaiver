# frozen_string_literal: true

require File.expand_path("boot", __dir__)

require "rails/all"
require_relative "lando_env"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:assets, :doc, :json_api, :net, :rake, *Rails.groups)

module Waiver
  VERSION = "0.0.1"

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

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
  end
end
