# frozen_string_literal: true

namespace :oawaiver do
  namespace :postgresql do
    desc "Copy the PostgreSQL database export into the server environment"
    task :copy, :sql_file do |_t, args|
      sql_file = args[:sql_file]
      sql_file_path = Pathname.new(sql_file)

      on roles(:app) do |_host|
        remote_file_path = File.join(current_path, sql_file_path.basename)

        begin
          upload!(sql_file_path, remote_file_path)
        rescue StandardError => scp_error
          $stderr.puts(scp_error.message)
        end
      end
    end

    desc "Import the SQL database export into the server environment"
    task :import, :sql_file do |_t, args|
      sql_file = args[:sql_file]
      sql_file_path = Pathname.new(sql_file)

      on roles(:app) do
        within current_path do
          with rails_env: fetch(:rails_env) do
            rake "oawaiver:postgresql:import[#{sql_file_path}]"
          end
        end
      end
    end
  end

  namespace :solr do
    desc "Delete and reindex data models into Solr with optimization"
    task :reindex do
      on roles(:app) do
        within current_path do
          with rails_env: fetch(:rails_env) do
            rake "oawaiver:solr:reindex"
          end
        end
      end
    end
  end
end
