# frozen_string_literal: true

# Load the Rails application.
require_relative "application"

begin
# Initialize the Rails application.
  Rails.application.initialize!
rescue StandardError => e
  #puts "Error during initialization: #{e.message}"
  puts e.backtrace
  raise e
end
