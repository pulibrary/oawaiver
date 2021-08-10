# frozen_string_literal: true

class DatabaseMigrationService
  # attr_reader :mysql_db_port, :postgresql_db_port
  def initialize(mysql_db_port: nil, postgresql_db_port: nil)
    @mysql_db_port = mysql_db_port
    @postgresql_db_port = postgresql_db_port
  end

  # def self.perform(import_file:)
  def import(sql_file_path:)
    exec_import(sql_file_path)
  end

  def migrate
    exec_migrate
  end

  private

  def postgresql_database_configuration
    Rails.configuration.database_configuration[Rails.env]
  end

  def db_user
    postgresql_database_configuration["username"]
  end

  def db_host
    postgresql_database_configuration["host"]
  end

  def db_name
    postgresql_database_configuration["database"]
  end

  def db_password
    postgresql_database_configuration["password"]
  end

  def mysql_database_configuration
    Rails.configuration.database_configuration["mysql"]
  end

  def mysql_db_user
    mysql_database_configuration["username"]
  end

  def mysql_db_host
    mysql_database_configuration["host"]
  end

  def mysql_db_name
    mysql_database_configuration["database"]
  end

  def mysql_db_password
    mysql_database_configuration["password"]
  end

  def mysql_db_port
    @mysql_db_port ||= mysql_database_configuration["port"]
  end

  def db_port
    postgresql_database_configuration["port"]
  end

  def postgresql_db_port
    @postgresql_db_port ||= db_port
  end

  def pgloader_bin_path
    "/usr/bin/env pgloader"
  end

  def mysql_uri
    "mysql://#{mysql_db_user}:#{mysql_db_password}@#{mysql_db_host}:#{mysql_db_port}/#{mysql_db_name}"
  end

  def postgresql_uri
    "postgresql://#{db_user}:#{db_password}@#{db_host}:#{postgresql_db_port}/#{db_name}"
  end

  def exec_migrate
    `#{pgloader_bin_path} #{mysql_uri} #{postgresql_uri}`
  end

  def mysql_bin_path
    "/usr/bin/env mysql"
  end

  def exec_import(sql_file_path)
    `#{mysql_bin_path} --host=#{mysql_db_host} --port=#{mysql_db_port} --user=#{mysql_db_user} --password=#{mysql_db_password} --database=#{mysql_db_name} < #{sql_file_path}`
  end
end

namespace :oawaiver do
  namespace :mysql do
    desc "Import the MySQL database export into MySQL"
    task :import, [:sql_file] => :environment do |_t, args|
      sql_file = args[:sql_file]
      sql_file_path = Pathname.new(sql_file)

      DatabaseMigrationService.import(sql_file_path: sql_file_path)
    end

    desc "Migrate the MySQL database export into PostgreSQL"
    task migrate: :environment do |_t, _args|
      DatabaseMigrationService.migrate
    end
  end
end

namespace :accounts do
  desc "Add the administrator role to a user account"
  task :add_admin_role, [:netid] => :environment do |_t, args|
    netid = args[:netid]

    account = Account.find_by(netid: netid)
    raise("Failed to find the user account: #{netid}") unless account

    account.role = Account::ADMIN_ROLE
    account.save
    $stdout.puts("Successfully added the administrator role to the account for #{netid}")
  end

  desc "Remove the administrator role to a user account"
  task :remove_admin_role, [:netid] => :environment do |_t, args|
    netid = args[:netid]

    account = Account.find_by(netid: netid)
    raise("Failed to find the user account: #{netid}") unless account

    account.role = Account::AUTHENTICATED_ROLE
    account.save
    $stdout.puts("Successfully removed the administrator role to the account for #{netid}")
  end
end
