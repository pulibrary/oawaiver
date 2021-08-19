# frozen_string_literal: true

module API
  module Entities
    class WaiverInfos < Grape::Entity
      %i[title journal author_last_name author_first_name author_department
         author_email author_unique_id requester requester_email id].each do |property|
        expose(property)
      end

      %i[created_at journal_issn notes].each do |property|
        expose(property, if: { type: :full })
      end
    end
  end
end
