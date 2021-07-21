# frozen_string_literal: true

load 'lib/author_status.rb'

init_file = 'config/author_status.yml'
options = YAML.load_file("#{::Rails.root}/#{init_file}")

begin
  AuthorStatus::Bootstrap(options)
rescue StandardError => e
  raise 'could not initialize from ' + init_file + ': ' + e.message
end
