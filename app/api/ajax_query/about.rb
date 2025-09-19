# frozen_string_literal: true

require "grape"

module AjaxQuery
  class About < Grape::API
    default_format :json
    use Rack::JSONP

    get "/" do
      result = { "revision" => Waiver::Application.config.revision }

      present(result)
    end
  end
end
