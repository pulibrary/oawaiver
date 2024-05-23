# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "actionpack", "~> 7.0.0", "< 7.1.0"
gem "actionview", "~> 7.0.0", "< 7.1.0"
gem "activemodel", "~> 7.0.0", "< 7.1.0"
gem "activerecord", "~> 7.0.0", "< 7.1.0"
gem "activesupport", "~> 7.0.0", "< 7.1.0"
gem "base64", "~> 0.1.1"
gem "bcrypt_pbkdf", "~> 1.1"
gem "bundler", "~> 2.3"
gem "dartsass-rails", "~> 0.5"
gem "devise", "~> 4.9"
gem "ed25519", "~> 1.3"
gem "grape", "~> 1.8"
gem "grape-entity", "~> 0.9"
gem "grape-swagger", "~> 1.4"
gem "grape-swagger-rails", "~> 0.4"
gem "honeybadger", "~> 5.8"
gem "jbuilder", "~> 2.0"
gem "jquery-rails", "~> 4.5"
gem "kaminari", "~> 1.2"
gem "mail"
gem "net-imap"
gem "net-pop"
gem "net-smtp"
gem "net-ssh", "7.0.0.beta1"
gem "omniauth", ">= 2.0.0"
gem "omniauth-cas", "~> 3.0"
gem "pg"
gem "propshaft", "~> 0.8"
gem "psych", "~> 3.3", "< 4"
gem "puma", "~> 5.6"
gem "rack", "~> 2.2"
gem "rack-contrib"
gem "rails", "~> 7.0.0", "< 7.1.0"
gem "railties", "~> 7.0.0", "< 7.1.0"
gem "sdoc", "~> 1.1", group: :doc
gem "sunspot_rails", "~> 2.6"
gem "sunspot_solr", "~> 2.6"
gem "vite_rails", "~> 3.0"
gem "will_paginate", "~> 3.3"
# Rake Task dependency
gem "progress_bar"
## Used to XLSX files
gem "roo", "~> 1.13.2"

group :development do
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-rails", "~> 1.4", require: false
end

group :test do
  gem "capybara"
  gem "coveralls_reborn", require: false
  gem "faker"
  gem "guard-rspec"
  gem "launchy"
end

group :development, :test do
  gem "bixby"
  gem "byebug"
  gem "database_cleaner-active_record", "~> 2.1"
  gem "factory_bot_rails", "~> 6.3"
  gem "foreman", "~> 0.87"
  gem "pry", "~> 0.14"
  gem "rails-controller-testing"
  gem "rspec-rails", "5.1"
  gem "yard"
end
