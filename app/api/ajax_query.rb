# frozen_string_literal: true

require "grape"

module AjaxQuery
  class API < Grape::API
    autoload(:About, "app/api/ajax_query/about")
    autoload(:Employees, "app/api/ajax_query/employees")
    autoload(:WaiverInfos, "app/api/ajax_query/waiver_infos")
  end
end
