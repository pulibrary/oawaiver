# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "bundler", "~> 2.1"

# Rails 6.1.7 releases are supported
gem "actionpack", "~> 6.1.7.7", "< 7"
gem "actionview", "~> 6.1.7.7", "< 7"
gem "activemodel", "~> 6.1.7.7", "< 7"
gem "activerecord", "~> 6.1.7.7", "< 7"
gem "activesupport", "~> 6.1.7.7", "< 7"
gem "rails", "~> 6.1.7.7", "< 7"
gem "railties", "~> 6.1.7.7", "< 7"

# Use Puma as the app server
gem "puma", "~> 5.6"

# YAML support
gem "psych", "~> 3.3", "< 4"

# PostgreSQL support
gem "pg"

# Rack support
gem "rack", "~> 2.2"
gem "rack-contrib"

# DSL for composing and sending e-mail messages
gem "mail"

# Integration the clients for the Apache Solr API
gem "sunspot_rails", "~> 2.6"
gem "sunspot_solr", "~> 2.6"

# Pagination for Solr search results
gem "kaminari", "~> 1.2"
gem "will_paginate", "~> 3.3"

# Single-Sign On support
gem "devise", "~> 4.9"
gem "omniauth-cas"

# Datadog Metrics
gem "ddtrace", "~> 1.21", require: "ddtrace/auto_instrument"

group :assets do
  gem "dartsass-rails", "~> 0.5"
  # jQuery support
  gem "jquery-rails", "~> 4.5"
  # Use SCSS for stylesheets
  # Integration for Vite in the Rails asset pipeline
  gem "vite_rails", "~> 3.0"
  # This must be removed, however, there are breaking changes which could not be isolated.
  # Please see https://github.com/rails/dartsass-rails/issues/37 for a likely-related error.
  gem "sassc"
end

group :doc do
  # This is used to generate the JSON API documentation
  # `bundle exec rake doc:rails` generates the API under doc/api.
  gem "sdoc", "~> 1.1", group: :doc
end

group :json_api do
  # JSON API with documentation
  gem "grape", "~> 1.5"
  gem "grape-entity", "~> 0.9"
  gem "grape-swagger", "~> 1.4"
  gem "grape-swagger-rails", "~> 0.4"

  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  gem "jbuilder", "~> 2.0"
end

group :net do
  gem "net-imap"
  gem "net-pop"
  gem "net-smtp"
  gem "net-ssh", "7.0.0.beta1"
end

group :rake do
  # Rake Task dependencies
  gem "progress_bar"
  ## Used to XLSX files
  gem "roo", "~> 1.13.2"
end

group :development do
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-rails", "~> 1.4", require: false
end

group :test do
  gem "capybara"
  gem "faker"
  gem "guard-rspec"
  gem "launchy"
end

group :development, :test do
  gem "bixby"
  gem "coveralls_reborn"
  gem "database_cleaner-active_record", "~> 2.1"
  gem "factory_bot_rails", "~> 6.3"
  gem "foreman", "~> 0.87"
  gem "pry", "~> 0.14"
  gem "rails-controller-testing"
  gem "rspec-rails", "5.1"
end
