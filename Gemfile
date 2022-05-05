# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "activerecord-pedantmysql2-adapter"
gem "bundler", "~> 2.1"
gem "devise"

# JSON API with documentation
gem "grape", "~> 1.5"
gem "grape-entity", "~> 0.9"
gem "grape-swagger", "~> 1.4"
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
gem "mysql2"
gem "omniauth-cas"
gem "pg"
gem "progress_bar"
gem "psych", "~> 3.3", "< 4"
gem "rack", "~> 2.2"
gem "rack-contrib"
gem "rails", "~> 6.0.4", "< 6.1"
gem "responders", "~> 3.0"

# read xls files
gem "roo", "~> 1.13.2"

# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 1.1", group: :doc
gem "sprockets", "~> 3.0"

gem "sunspot_rails", github: "sunspot/sunspot", glob: "sunspot_rails/*.gemspec", ref: "6cddd9f"
gem "sunspot_solr", github: "sunspot/sunspot", glob: "sunspot_solr/*.gemspec", ref: "6cddd9f"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"
gem "webpacker"
gem "will_paginate", "~> 3.3"

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
  gem "capistrano-passenger"
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
  gem "database_cleaner-active_record"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "rails-controller-testing"
  gem "rspec-rails"
end

group :production do
  gem "ddtrace", require: "ddtrace/auto_instrument"
  gem "execjs"
  gem "therubyracer"
end
