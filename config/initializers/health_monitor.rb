# frozen_string_literal: true
Rails.application.config.after_initialize do
  HealthMonitor.configure do |config|
    config.cache

    config.solr.configure do |c|
      url = Sunspot.config.solr.url
      uri = URI(url)
      status_uri = URI("#{uri.scheme}://#{uri.hostname}:#{uri.port}/solr/admin/cores?action=STATUS")

      c.url = status_uri.to_s
    end

    config.path = :health

    config.file_absence.configure do |file_config|
      file_config.filename = "public/remove-from-nginx"
    end

    config.error_callback = proc do |e|
      Rails.logger.error "Health check failed with: #{e.message}"
      Honeybadger.notify(e) unless e.is_a?(HealthMonitor::Providers::FileAbsenceException)
    end
  end
end
