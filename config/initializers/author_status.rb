# frozen_string_literal: true

require Rails.root.join("app", "lib", "author_status.rb")

begin
  config_file_path = Rails.root.join("config", "author_status.yml")
  AuthorStatus.build_from_config(file_path: config_file_path)
rescue StandardError => e
  raise("Could not initialize AuthorStatus from #{config_file_path}: #{e.message}")
end
