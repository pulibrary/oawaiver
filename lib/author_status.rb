# frozen_string_literal: true

require "uri"

class AuthorStatus
  @status_faculty = nil
  @status_other = nil

  @ajax_info = []

  @ajax_path = nil
  @ajax_match_params = nil
  @status_path = nil

  @get_unique_id_url = {}

  DEFAULT_STATUS = "non faculty"
  FACULTY_STATUS = "faculty"
  UNKNOWN_STATUS = "unknown"

  def self.unique_id_urls
    @get_unique_id_url
  end

  def self.unique_id_paths
    @get_unique_id_path
  end

  class << self
    attr_reader :current_config
  end

  def self.bootstrap(opts)
    return if current_config

    # @status_faculty = "faculty"
    # @status_other = "non faculty"
    # @status_unknonw = "unknown"

    # raise "must define 'faculty', and 'other' author_status values" if @status_faculty.nil? || @status_other.nil?

    @status_other = DEFAULT_STATUS
    @status_faculty = FACULTY_STATUS
    @status_unknonw = UNKNOWN_STATUS

    # @base_url = opts[Rails.env]["base_url"] || ""
    @current_config = opts[Rails.env]
    @base_url = current_config.fetch("base_url", "")

    # unless @base_url.empty?
    #  u = URI(@base_url)
    #  raise "malformed base_url: #{@base_url}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)
    # end

    # @ajax_path = opts["ajax_path"]
    # @ajax_match_params = opts["ajax_params"]
    @ajax_path = current_config["ajax_path"]
    @ajax_match_params = current_config["ajax_params"]

    # unless @base_url.empty?
    #  u = URI(self.AjaxUrl)
    #  raise "malformed ajax url: #{u.host}/#{u.path}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)
    # end

    # @status_path = opts["status_path"]
    @status_path = current_config["status_path"]
    # unless @base_url.empty?
    #  u = URI(self.StatusUrl)
    #  raise "malformed status_path: #{@status_path}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)
    # end

    # @get_unique_id_path = opts["get_unique_id_path"]
    @get_unique_id_path = current_config["get_unique_id_path"]
    return if base_url.blank?

    # u = URI(@base_url)
    # raise "malformed base_url: #{@base_url}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)
    # u = URI(self.AjaxUrl)
    # raise "malformed ajax url: #{u.host}/#{u.path}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)
    # u = URI(self.StatusUrl)
    # raise "malformed status_path: #{@status_path}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)

    %w[html json].each do |format|
      # raise "missing '#{format}' entry in get_unique_id_path " if @get_unique_id_path[format].nil?
      raise("Missing the AuthorStatus '#{format}' configuration entry for :get_unique_id_path.") unless unique_id_paths.key?(format)

      # next if @base_url.empty?

      # u = URI(self.GetUniqueIdUrl("test", format))
      # test_unique_id_url = get_unique_id_path("test", format)
      # test_unique_id_uri = URI(test_unique_id_url)

      # raise "malformed get_unique_id_path[#{format}: #{@get_unique_id_path[format]}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)
    end
  end

  def self.build_from_config(file_path:)
    config = YAML.load_file(file_path)
    bootstrap(config)
  end

  def base_uri
    URI(base_url)
  end

  def ajax_uri
    URI(ajax_url)
  end

  def status_uri
    URI(status_url)
  end

  # def self.StatusFaculty
  def self.status_faculty
    FACULTY_STATUS
  end

  def self.faculty_status?(status)
    status_faculty == status
  end

  # def self.StatusOther
  def self.status_other
    DEFAULT_STATUS
  end

  # def self.StatusList
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

  # def self.AjaxUrl
  def self.ajax_url
    # @base_url + "/" + @ajax_path.html_safe

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

  # def self.AjaxParams
  def self.ajax_params
    safe_ajax_params
  end

  # def self.StatusUrl
  def self.status_url
    # @base_url + "/" + @status_path.html_safe
    segments = [
      base_url,
      safe_ajax_path
    ]

    segments.join("/")
  end

  # def self.SetBaseUrl=(base)
  class << self
    attr_writer :base_url
  end

  # def self.GetUniqueIdUrl(uid, format = nil)
  def self.generate_uid_url(uid, format = "html")
    # format ||= "html"
    # @base_url + "/" + @get_unique_id_path[format].gsub(/MATCH/, Rack::Utils.escape(uid)).html_safe

    escaped_uid = Rack::Utils.escape(uid)
    unique_id_path = unique_id_paths[format]
    uid_path = unique_id_path.gsub(/MATCH/, escaped_uid)
    safe_uid_path = uid_path.html_safe
    segments = [
      base_url,
      safe_uid_path
    ]

    segments.join("/")
  end

  # def self.GetBaseUrl
  class << self
    attr_reader :base_url
  end
end
