# frozen_string_literal: true

desc 'Invoke a rake command on the remote server'
task rake: 'deploy:set_rails_env' do
  on primary(:app) do
    within current_path do
      with rails_env: fetch(:rails_env) do
        ask(:args, '--tasks')
        rake fetch(:args)
      end
    end
  end
end
