# frozen_string_literal: true

require "grape"

module AjaxQuery
  class API < Grape::API
    default_format :json

    mount Employees => "/employees"
    mount WaiverInfos => "/waiver"
    mount About => "/about"

    add_swagger_documentation(
      base_path: "/api",
      hide_documentation_path: true
    )
  end
end
