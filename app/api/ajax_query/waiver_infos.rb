# frozen_string_literal: true
require "rack/contrib"

module AjaxQuery
  class WaiverInfos < Grape::API
    use Rack::JSONP

    rescue_from :all do |errors|
      error_response({ errors: errors })
    end

    desc "return all waivers with matching words"
    params do
      requires :search_term, type: String, desc: "match against title, author, depatment, ..."
    end
    get "get_all/words" do
      search_term = params[:search_term]

      matches = WaiverInfo.all_with_words(search_term)
      present matches.results, with: Entities::WaiverInfos, type: :full
    end
  end
end
