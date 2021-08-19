# frozen_string_literal: true
require "rack/contrib"

module API
  class WaiverInfos < Grape::API
    use Rack::JSONP

    rescue_from :all do |e|
      error_response({ errors: e })
    end

    desc "return all waivers with matching words"
    params do
      requires :search_term, type: String, desc: "match against title, author, depatment, ..."
    end
    get "get_all/words" do
      matches = WaiverInfo.all_with_words(params[:search_term])
      present matches.results, with: API::Entities::WaiverInfos, type: :full
    end
  end
end
