# frozen_string_literal: true

set :application, "oawaiver"
set :repo_url, "https://github.com/pulibrary/oawaiver.git"

# This will keep deploys from hubot-deploy working as expected
branch = ENV["BRANCH"] || "main"
set :branch, branch

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/opt/oawaiver"

Rake::Task["deploy:assets:backup_manifest"].clear_actions
Rake::Task["deploy:assets:restore_manifest"].clear_actions

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, [])

# Default value for linked_dirs is []
# set :linked_dirs, []
set :linked_dirs, fetch(:linked_dirs, []).push("log", "vendor/bundle")

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :passenger_restart_with_touch, true

namespace :deploy do
  desc "Build CSS from Sass using Yarn"
  task :yarn_build_css do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn build:css && bundle exec rails dartsass:build")
      end
    end
  end
end

# before "deploy:assets:precompile", "deploy:yarn_build_css"
