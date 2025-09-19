# frozen_string_literal: true

# GrapeSwaggerRails.options.url      = "/api/swagger_doc.json"
# GrapeSwaggerRails.options.app_name = "Employees"
# GrapeSwaggerRails.options.app_url  = "/"
#
# rest_api_path = Rails.root.join("app", "api", "**", "*rb")
# Dir.glob(rest_api_path).each { |path| require(path) }
api_path = Rails.root.join("app", "api", "ajax_query.rb")
api_paths = [api_path]
api_paths.each do |path|
  require(path)
end
