# frozen_string_literal: true

require "pry-byebug"

namespace :oawaiver do
  namespace :postgresql do
    desc "Migrate and import the PostgreSQL database export into the server environment"
    task :copy, :sql_file do |_t, args|
      on roles(:app) do |_host|
        sql_file = args[:sql_file]
        sql_file_path = Pathname.new(sql_file)

        remote_file_path = File.join(current_path, sql_file_path.basename)

        begin
          upload!(sql_file_path, remote_file_path)
        rescue StandardError => scp_error
          $stderr.puts(scp_error.message)
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
