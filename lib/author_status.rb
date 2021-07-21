require 'uri'

class AuthorStatus

  private

  @@status_faculty = nil;
  @@status_other = nil;

  @@ajax_info = [];

  @@ajax_path = nil;
  @@ajax_match_params = nil;
  @@status_path = nil;

  @@get_unique_id_url = {};

  public

  def self.Bootstrap(opts)
    if (true || @@status_faculty.nil?) then
      @@status_faculty = 'faculty';
      @@status_other =  'non faculty';
      @@status_unknonw = "unknown";

      if (@@status_faculty.nil? || @@status_other.nil?) then
        raise "must define 'faculty', and 'other' author_status values"
      end

      @@base_url = opts[Rails.env()]['base_url'] || "";
      unless @@base_url.empty?
        u = URI(@@base_url);
        if (not u.kind_of?(URI::HTTP) and not u.kind_of?(URI::HTTPS)) then
          raise "malformed base_url: #{@@base_url}"
        end
      end

      @@ajax_path = opts['ajax_path'];
      @@ajax_match_params = opts['ajax_params'];
      unless @@base_url.empty?
        u = URI(self.AjaxUrl);
        if (not u.kind_of?(URI::HTTP) and not u.kind_of?(URI::HTTPS)) then
          raise "malformed ajax url: #{u.host}/#{u.path}"
        end
      end

      @@status_path = opts['status_path'];
      unless @@base_url.empty?
        u = URI(self.StatusUrl);
        if (not u.kind_of?(URI::HTTP) and not u.kind_of?(URI::HTTPS)) then
          raise "malformed status_path: #{@@status_path}"
        end
      end

      @@get_unique_id_path = opts['get_unique_id_path'];
      ['html', 'json'].each do |format|
        if @@get_unique_id_path[format].nil? then
          raise "missing '#{format}' entry in get_unique_id_path ";
        end
        unless @@base_url.empty?
          u = URI(self.GetUniqueIdUrl('test', format));
          if (not u.kind_of?(URI::HTTP) and not u.kind_of?(URI::HTTPS)) then
            raise "malformed get_unique_id_path[#{format}: #{@@get_unique_id_path[format]}"
          end
        end
      end
    end
  end

  def self.StatusFaculty()
    return @@status_faculty;
  end

  def self.StatusOther()
    return @@status_other;
  end

  def self.StatusList()
    return [@@status_faculty, @@status_other, @@status_unknonw]
  end

  def self.WithAjaxInfo(status)
    return status == @@status_faculty;
  end

  def self.AjaxUrl()
    return @@base_url + "/" + @@ajax_path.html_safe();
  end

  def self.AjaxParams()
    return @@ajax_match_params.html_safe();
  end

  def self.StatusUrl()
    return @@base_url + "/" + @@status_path.html_safe();
  end

  def self.SetBaseUrl=(base)
    @@base_url = base;
  end

  def self.GetUniqueIdUrl(uid, format= nil)
    format = format || "html";
    return @@base_url + "/" + @@get_unique_id_path[format].gsub(/MATCH/, Rack::Utils.escape(uid)).html_safe();
  end

  def self.GetBaseUrl()
    return @@base_url;
  end

end