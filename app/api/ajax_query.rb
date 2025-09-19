# frozen_string_literal: true

require "grape"

module AjaxQuery
  class API < Grape::API
    autoload(:About, "app/api/ajax_query/about")
  end
end
