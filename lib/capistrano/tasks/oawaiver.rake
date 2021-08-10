# frozen_string_literal: true

require 'pry-byebug'

namespace :oawaiver do
  namespace :postgresql do
    desc "Migrate and import the PostgreSQL database export into the server environment"
    task :copy, :sql_file do |_t, args|
      on roles(:app) do |host|
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
end
