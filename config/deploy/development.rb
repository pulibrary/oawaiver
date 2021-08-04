# frozen_string_literal: true
# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}
server "localhost", user: "vagrant", roles: %w[app db web]

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.

set :pty, true
set :default_shell, '/bin/bash --login'
set :shell, '/bin/bash --login'

SSHKit.config.command_map[:ruby] = "/usr/local/rvm/rubies/ruby-2.7.3/bin/ruby"
set :ruby_version, "/usr/local/rvm/rubies/ruby-2.7.3/bin"

set :default_env, {
  'PATH' => "/usr/local/rvm/rubies/ruby-2.7.3/bin:/usr/local/rvm/gems/ruby-2.7.3/bin:$PATH",
  'RUBY_VERSION' => '2.7.3',
  'GEM_HOME' => '/usr/local/rvm/gems/ruby-2.7.3',
  'GEM_PATH' => '/usr/local/rvm/gems/ruby-2.7.3',
  'BUNDLE_PATH' => '/usr/local/rvm/gems/ruby-2.7.3'
}

namespace :rvm do
  task :trust_rvmrc do
    on roles(:all) do
      execute "rvm rvmrc trust #{release_path}"
    end
  end
end
after "deploy", "rvm:trust_rvmrc"

namespace :deploy do
  task :load_rvm do
    on roles(:all) do
      execute "source /usr/local/rvm/scripts/rvm"
      SSHKit.config.command_map[:ruby] = "/usr/local/rvm/rubies/ruby-2.7.3/bin/ruby"
    end
  end
end
after "deploy:updating", "deploy:load_rvm"

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/user_name/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "example.com",
#   user: "user_name",
#   roles: %w{web app},
#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }

def vagrant_key_path
  current_path = File.expand_path(__FILE__)
  parent_dir = File.dirname(current_path)
  root_path = File.join(parent_dir, '..', '..', 'vagrant')
  File.join(root_path, '.vagrant', 'machines', 'default', 'virtualbox', 'private_key')
end

server "localhost",
  user: "vagrant",
  roles: %w[app db web],
  ssh_options: {
    keys: [vagrant_key_path],
    forward_agent: false,
    auth_methods: %w[publickey password],
    port: 2222
  }
