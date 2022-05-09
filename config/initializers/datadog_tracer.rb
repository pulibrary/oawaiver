# frozen_string_literal: true

require "ddtrace/auto_instrument"

Datadog.configure do |c|
  c.tracing.enabled = false unless Rails.env.production?

  c.service = "oawaiver"
  c.env = "production"
end
