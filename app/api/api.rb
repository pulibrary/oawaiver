# frozen_string_literal: true

require 'grape'

module API
  class Base < Grape::API
    default_format :json

    mount API::Employees => '/employees'
    mount API::WaiverInfos => '/waiver'
    mount API::About => '/about'

    add_swagger_documentation(
      base_path: '/api',
      hide_documentation_path: true
    )
  end
end
