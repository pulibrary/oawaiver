# frozen_string_literal: true

module AjaxQuery
  class About < API
    use Rack::JSONP

    def show
      result = { "revision" => Waiver::Application.config.revision }

      render json: result
    end
  end
end
