# frozen_string_literal: true

require "grape"

module AjaxQuery
  api_path = Rails.root.join("app", "api", "ajax_query")
  autoload(:About, api_path.join("about"))
  autoload(:Employees, api_path.join("employees"))
  autoload(:WaiverInfos, api_path.join("waiver_infos"))

  class API < Grape::API
    default_format :json

    mount(About => "/about")
    mount(Employees => "/employees")
    mount(WaiverInfos => "/waiver")
  end
end
