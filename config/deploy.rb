# frozen_string_literal: true

set :application, "oawaiver"
set :repo_url, "https://github.com/pulibrary/oawaiver.git"

# This will keep deploys from hubot-deploy working as expected
def set_branch
  branch = ENV["BRANCH"] || "main"
  return branch unless branch == "master"
  "main"
end
set :branch, set_branch

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'
set :deploy_to, "/opt/oawaiver"

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
set :linked_dirs, fetch(:linked_dirs, []).push("log",
                                               "vendor/bundle")

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :passenger_restart_with_touch, true

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, "cache:clear"
      end
    end
  end
end
