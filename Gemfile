# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "bundler", "~> 2.1"

# Rails 6.1.7 releases are supported
gem "rails", "~> 6.1.7", "< 7"

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
gem "kaminari"
gem "will_paginate", "~> 3.3"

# Rails Controller patterns for HTTP responses
gem "responders", "~> 3.0"

# Single-Sign On support
gem "devise"
gem "omniauth-cas"

group :assets do
  # jQuery support
  gem "jquery-rails"
  # Use SCSS for stylesheets
  gem "sass-rails", "~> 5.1"
  # Integration for Vite in the Rails asset pipeline
  gem "vite_rails", "~> 3.0", ">= 3.0.15"
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
  gem "grape-swagger-rails", "~> 0.3"

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
  gem "better_errors"
  gem "binding_of_caller"
  # For integrating Capistrano
  gem "capistrano"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  # For debugging
  gem "pry-byebug"
  # This is required for `rails server`
  gem "thin"
end

group :test do
  gem "capybara"
  gem "faker"
  gem "guard-rspec"
  gem "launchy"
end

group :development, :test do
  gem "bixby"
  gem "coveralls"
  gem "database_cleaner-active_record"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rspec-rails"
end

group :production do
  gem "ddtrace", require: "ddtrace/auto_instrument"
end
