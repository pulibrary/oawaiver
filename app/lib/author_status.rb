# frozen_string_literal: true

require "uri"

class AuthorStatus
  @status_faculty = nil
  @status_other = nil

  @ajax_info = []

  @ajax_path = nil
  @ajax_match_params = nil
  @status_path = nil

  @unique_id_urls = {}

  DEFAULT_STATUS = "non faculty"
  FACULTY_STATUS = "faculty"
  UNKNOWN_STATUS = "unknown"

  class << self
    attr_reader :current_config, :get_unique_id_path, :unique_id_urls
    attr_writer :base_url
  end

  def self.build_base_url(context: nil)
    if context&.respond_to?(:request)
      request = context.request
      "#{request.protocol}#{request.host_with_port}#{@base_url}"
    else
      @base_url
    end
  end

  def self.bootstrap(opts)
    return if current_config

    @status_other = DEFAULT_STATUS
    @status_faculty = FACULTY_STATUS
    @status_unknonw = UNKNOWN_STATUS

    @current_config = opts[Rails.env]
    @base_url = current_config.fetch("base_url", "")

    @ajax_path = current_config["ajax_path"]
    config_ajax_params = current_config["ajax_params"]
    @ajax_match_params = config_ajax_params

    @status_path = current_config["status_path"]
    @get_unique_id_path = current_config["get_unique_id_path"]
    return if @base_url.blank?

    %w[html json].each do |format|
      unless get_unique_id_path.key?(format)
        raise("Missing the AuthorStatus '#{format}' configuration entry for :get_unique_id_path.")
      end
    end
  end

  # Bootstrap the AuthorStatus class with the configuration from the given file.
  #
  # @param file_path [String] the path to the configuration file
  # @return [void]
  def self.build_from_config(file_path:)
    config = YAML.load_file(file_path)
    bootstrap(config)
  end

  def self.status_faculty
    FACULTY_STATUS
  end

  def self.faculty_status?(status)
    status_faculty == status
  end

  def self.status_other
    DEFAULT_STATUS
  end

  def self.status_list
    [
      FACULTY_STATUS,
      DEFAULT_STATUS,
      UNKNOWN_STATUS
    ]
  end

  def self.safe_ajax_path
    @ajax_path.html_safe
  end

  def self.ajax_url(context: nil)
    base_url = build_base_url(context: context)

    safe_ajax_path = @ajax_path.html_safe
    segments = [
      base_url,
      safe_ajax_path
    ]

    segments.join("/")
  end

  def self.safe_ajax_params
    @ajax_match_params.html_safe
  end

  def self.ajax_params
    safe_ajax_params
  end

  def self.status_url(context: nil)
    base_url = build_base_url(context: context)

    segments = [
      base_url,
      safe_ajax_path
    ]

    segments.join("/")
  end

  def self.generate_uid_url(uid, format = "html", context: nil)
    escaped_uid = Rack::Utils.escape(uid)
    unique_id_path = get_unique_id_path[format]
    uid_path = unique_id_path.gsub(/MATCH/, escaped_uid)
    safe_uid_path = uid_path.html_safe

    base_url = build_base_url(context: context)

    segments = [
      base_url,
      safe_uid_path
    ]

    segments.join("/")
  end
end
