# frozen_string_literal: true

require "rack/contrib"

module AjaxQuery
  class WaiverInfos < API
    use Rack::JSONP

    rescue_from :all do |errors|
      error_response({ errors: errors })
    end

    # get "get_all/words" do
    def get_waivers_by_words
      search_term = params[:search_term]

      models = WaiverInfo.all_with_words(search_term)

      render json: models
    end
  end
end
