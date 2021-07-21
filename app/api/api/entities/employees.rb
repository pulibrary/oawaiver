module API
  module Entities
    class Employees < Grape::Entity
      [:unique_id, :preferred_name, :department].each { |prop|
        expose prop
      }
      [:first_name,  :last_name, :email, :netid].each { |prop|
       expose prop, if: { type: :full }
      }
    end

  end
end
