# frozen_string_literal: true

require "rails_helper"

describe AuthorStatus do
  let(:config_file_path) { Rails.root.join("config", "author_status.yml") }
  let(:config_keys) { ["ajax_path", "ajax_params", "status_path", "get_unique_id_path", "base_url"] }

  it "loads configuration from a config file" do
    AuthorStatus.build_from_config(file_path: config_file_path)
    expect(described_class.current_config.keys).to eq config_keys
  end

  it "gets unique id urls" do
    urls = described_class.unique_id_urls
    expect(urls).to be_a(Hash)
  end

  it "gets unique id paths" do
    paths = described_class.unique_id_paths
    expect(paths).to eq({ "html" => "employees/get/MATCH", "json" => "api/employees/get/unique_id.json?id=MATCH" })
  end
end
