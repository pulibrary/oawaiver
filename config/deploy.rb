# frozen_string_literal: true

set :application, 'oawaiver'
set :repo_url, 'https://github.com/pulibrary/oawaiver.git'

set :branch, ENV['BRANCH'] || 'main'

set :deploy_to, '/opt/oawaiver'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w[config/database.yml]

# Default value for linked_dirs is []
# set :linked_dirs, %w[bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system]
set :linked_files, fetch(:linked_dirs, []).push("log", "vendor/bundle")

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

after 'deploy:published', 'deploy:migrate'
