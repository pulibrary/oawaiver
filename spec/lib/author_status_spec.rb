# frozen_string_literal: true

require "rails_helper"

describe AuthorStatus do
  let(:config_file_path) { Rails.root.join("config", "author_status.yml") }
  let(:config_keys) { ["ajax_path", "ajax_params", "status_path", "get_unique_id_path", "base_url"] }

  it "loads configuration from a config file" do
    # Note that the config file is generally loaded in an initializer at
    # application startup. See config/initializers/author_status.rb
    AuthorStatus.build_from_config(file_path: config_file_path)
    expect(described_class.current_config.keys).to eq config_keys
  end

  it "gets unique id urls" do
    urls = described_class.unique_id_urls
    expect(urls).to be_a(Hash)
  end

  it "gets unique id paths" do
    paths = described_class.get_unique_id_path
    expect(paths).to eq({ "html" => "employees/get/MATCH", "json" => "api/employees/get/unique_id.json?id=MATCH" })
  end

  describe ".generate_uid_url" do
    let(:uid) { "123456789" }

    it "generates the URL from a given UID" do
      url = described_class.generate_uid_url(uid)
      expect(url).to eq("//employees/get/123456789")
    end
  end
end
