# frozen_string_literal: true

source "https://rubygems.org"

gem "actionpack", ">= 5.2.4.6"
gem "actionview", ">= 5.2.4.4"
gem "bundler", "~> 2.1"
gem "devise"
# JSON API with documentation
gem "grape", "~> 1.1.0"
gem "grape-entity", "~> 0.4.0"
gem "grape-swagger", "~> 0.7.2"
gem "grape-swagger-rails", "~> 0.3"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"
# Use jquery as the JavaScript library
gem "jquery-rails"
gem "json", ">= 2.3.0"
gem "kaminari"
# rake tasks
gem "lumberjack"
gem "mail"
# Modernizr
gem "modernizr-rails"
gem "mysql2", "~> 0.5"
gem "omniauth-cas"
gem "progress_bar"
gem "rack", ">= 2.1.4"
gem "rack-contrib", "~> 2.1"
gem "rails", ">= 5.2.6", "< 6.0"
gem "responders", "~> 2.0"
# read xls files
gem "roo", "~> 1.13.2"
# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 1.1", group: :doc
gem "sprockets", "~> 3.0"
gem "sunspot_rails"
gem "sunspot_solr"
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"
gem "will_paginate", "~> 3.0.6"

group :assets do
  # Use CoffeeScript for .js.coffee assets and views
  gem "coffee-rails", "~> 5.0"
  # Use SCSS for stylesheets
  gem "sass-rails", "~> 5.1"
  # Use Uglifier as compressor for JavaScript assets
  gem "uglifier", ">= 1.3.0"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  # Use Capistrano
  gem "capistrano"
  gem "capistrano-bundler"
  gem "capistrano-rails"
end

group :test do
  gem "capybara"
  gem "faker"
  gem "guard-rspec"
  gem "launchy"
  gem "sqlite3"
end

group :development, :test do
  gem "bixby"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "rails-controller-testing"
  gem "rspec-rails"
end

group :production, :qa do
  gem "execjs"
  gem "therubyracer"
end
