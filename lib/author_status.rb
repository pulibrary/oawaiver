# frozen_string_literal: true

require "uri"

class AuthorStatus
  @@status_faculty = nil
  @@status_other = nil

  @@ajax_info = []

  @@ajax_path = nil
  @@ajax_match_params = nil
  @@status_path = nil

  @@get_unique_id_url = {}

  def self.Bootstrap(opts)
    return unless @@status_faculty.nil?

    @@status_faculty = "faculty"
    @@status_other = "non faculty"
    @@status_unknonw = "unknown"

    raise "must define 'faculty', and 'other' author_status values" if @@status_faculty.nil? || @@status_other.nil?

    @@base_url = opts[Rails.env]["base_url"] || ""
    unless @@base_url.empty?
      u = URI(@@base_url)
      raise "malformed base_url: #{@@base_url}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)
    end

    @@ajax_path = opts["ajax_path"]
    @@ajax_match_params = opts["ajax_params"]
    unless @@base_url.empty?
      u = URI(self.AjaxUrl)
      raise "malformed ajax url: #{u.host}/#{u.path}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)
    end

    @@status_path = opts["status_path"]
    unless @@base_url.empty?
      u = URI(self.StatusUrl)
      raise "malformed status_path: #{@@status_path}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)
    end

    @@get_unique_id_path = opts["get_unique_id_path"]
    %w[html json].each do |format|
      raise "missing '#{format}' entry in get_unique_id_path " if @@get_unique_id_path[format].nil?

      next if @@base_url.empty?

      u = URI(self.GetUniqueIdUrl("test", format))
      raise "malformed get_unique_id_path[#{format}: #{@@get_unique_id_path[format]}" if !u.is_a?(URI::HTTP) && !u.is_a?(URI::HTTPS)
    end
  end

  def self.StatusFaculty
    @@status_faculty
  end

  def self.StatusOther
    @@status_other
  end

  def self.StatusList
    [@@status_faculty, @@status_other, @@status_unknonw]
  end

  def self.WithAjaxInfo(status)
    status == @@status_faculty
  end

  def self.AjaxUrl
    @@base_url + "/" + @@ajax_path.html_safe
  end

  def self.AjaxParams
    @@ajax_match_params.html_safe
  end

  def self.StatusUrl
    @@base_url + "/" + @@status_path.html_safe
  end

  def self.SetBaseUrl=(base)
    @@base_url = base
  end

  def self.GetUniqueIdUrl(uid, format = nil)
    format ||= "html"
    @@base_url + "/" + @@get_unique_id_path[format].gsub(/MATCH/, Rack::Utils.escape(uid)).html_safe
  end

  def self.GetBaseUrl
    @@base_url
  end
end
