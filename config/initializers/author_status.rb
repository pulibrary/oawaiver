load "lib/author_status.rb"

init_file = "config/author_status.yml";
options = YAML.load_file("#{::Rails.root.to_s}/#{init_file}");

begin
  AuthorStatus::Bootstrap(options);
rescue Exception => e
  raise "could not initialize from " + init_file + ": " + e.message
end
