# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# gem "abbrev", "~> 0.1.2"
gem "actionpack", "~> 7.2.2"
gem "actionview", "~> 7.2.2", "< 8.0"
gem "activemodel", "~> 7.2.2", "< 8.0"
gem "activerecord", "~> 7.2.2", "< 8.0"
gem "activesupport", "~> 7.2.2", "< 8.0"

gem "base64"
gem "bcrypt_pbkdf"
gem "bundler", "~> 2.3"
gem "dartsass-rails"
gem "devise", "~> 4.9"
gem "ed25519"
# gem "grape", "~> 1.8"
# gem "grape-entity", "~> 0.9"
# gem "grape-swagger", "~> 1.4"
# gem "grape-swagger-rails", "~> 0.4"
gem "health-monitor-rails"
gem "honeybadger"
gem "jbuilder"
gem "jquery-rails"
gem "kaminari"
gem "mail"
gem "net-imap"
gem "net-pop"
gem "net-smtp"
gem "net-ssh"
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

gem "rspec-retry"
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
  gem "guard-rspec"
  gem "launchy"
end

group :development, :test do
  gem "bixby"
  gem "byebug"
  gem "coveralls_reborn", "~> 0.28"
  gem "database_cleaner-active_record", "~> 2.1"
  gem "factory_bot_rails", "~> 6.3"
  gem "foreman", "~> 0.87"
  gem "pry", "~> 0.14"
  gem "rails-controller-testing"
  gem "rspec-rails", "5.1"
  gem "simplecov", "~> 0.22"
  gem "webmock"
  gem "yard"
end
