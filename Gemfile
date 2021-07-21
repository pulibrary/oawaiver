# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bundler', '~> 1.17'
gem 'rails', '~> 4.2'
gem 'responders', '~> 2.0'

gem 'mysql2'

group :assets do
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 4.0.3'
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails', '~> 4.0.0'
end

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Modernizr
gem 'modernizr-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use Capistrano
gem 'capistrano'
gem 'capistrano-bundler'
gem 'capistrano-rails'

gem 'mail'
gem 'will_paginate', '~> 3.0.6'

gem 'rubycas-client', git: 'https://github.com/ratliff/rubycas-client.git', branch: 'rails4-fix'

gem 'kaminari'

gem 'progress_bar'
gem 'sunspot_rails'
gem 'sunspot_solr'

# read xls files
gem 'roo', '~> 1.13.2'

# rake tasks
gem 'lumberjack'

# json api with documentation
gem 'grape', '~> 1.1.0'
gem 'grape-entity', '~> 0.4.0'
gem 'grape-swagger', '~> 0.7.2'
gem 'grape-swagger-rails', '~> 0.0.8'
gem 'rack-contrib', '~> 1.1.0'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'bixby'
  gem 'factory_girl_rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'sqlite3'
end

group :production, :qa do
  gem 'execjs'
  gem 'therubyracer'
end
