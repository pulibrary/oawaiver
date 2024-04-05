# frozen_string_literal: true

module AjaxQuery
  module Entities
    class Employees < Grape::Entity
      %i[unique_id preferred_name department].each do |property|
        expose(property)
      end

      %i[first_name last_name email netid].each do |property|
        expose(property, if: { type: :full })
      end
    end
  end
end
