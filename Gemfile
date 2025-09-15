# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "actionpack", "~> 7.2.2"
gem "actionview", "~> 7.2.2", "< 8.0"
gem "activemodel", "~> 7.2.2", "< 8.0"
gem "activerecord", "~> 7.2.2", "< 8.0"
gem "activesupport", "~> 7.2.2", "< 8.0"

gem "base64"
gem "bcrypt_pbkdf"
gem "bundler", "~> 2.6"
gem "dartsass-rails"
gem "devise", "~> 4.9"
gem "ed25519"

gem "health-monitor-rails"
gem "honeybadger"
gem "jbuilder"
gem "mail"
gem "nokogiri"
gem "omniauth"
gem "omniauth-cas"
gem "pg"

# gem "propshaft", "~> 0.8"
gem "psych"
# gem "puma", "~> 5.6"
gem "rack"
gem "rack-contrib"

gem "rails", "~> 7.2.2", "< 8.0"
gem "railties", "~> 7.2.2", "< 8.0"

# gem "sdoc", "~> 1.1", group: :doc
gem "sunspot_rails"
gem "sunspot_solr"

gem "vite_rails"
gem "will_paginate"
# Rake Task dependency
# gem "progress_bar"
## Used to XLSX files
# gem "roo", "~> 1.13.2"

group :development do
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-rails", "~> 1.4", require: false
end

group :test do
  gem "capybara"
  gem "faker"
  gem "launchy"
end

group :development, :test do
  gem "coveralls_reborn", "~> 0.28"
  gem "database_cleaner-active_record", "~> 2.2"
  gem "factory_bot_rails", "~> 6.3"
  gem "foreman", "~> 0.87"
  gem "rails-controller-testing"
  gem "rspec-rails", "8.0"
  gem "rubocop-rails", "~> 2.33", ">= 2.33.3"
  gem "rubocop-rspec", "~> 3.7"
  gem "simplecov"
  gem "webmock"
  gem "yard"
end
