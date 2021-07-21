# frozen_string_literal: true

module API
  module Entities
    class Employees < Grape::Entity
      %i[unique_id preferred_name department].each do |prop|
        expose prop
      end
      %i[first_name last_name email netid].each do |prop|
        expose prop, if: { type: :full }
      end
    end
  end
end
