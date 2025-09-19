# frozen_string_literal: true

require "grape"

module AjaxQuery
  module Entities
    class API < Grape::API
      autoload(:Employees, "app/api/ajax_query/entities/employees")
      autoload(:WaiverInfos, "app/api/ajax_query/entities/waiver_infos")
    end
  end
end
