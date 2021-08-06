# frozen_string_literal: true

module API
  class About < Grape::API
    use Rack::JSONP

    desc "return about information including version"
    get "" do
      result = { "revision" => Waiver::Application.config.revision }
      present result
    end
  end
end
