module API
  module Entities
    class WaiverInfos < Grape::Entity
      [:title, :journal, :author_last_name, :author_first_name, :author_department,
         :author_email, :author_unique_id, :requester, :requester_email, :id].each { |prop|
        expose prop
      }
      [:created_at,  :journal_issn, :notes].each { |prop|
       expose prop, if: { type: :full }
      }
    end

  end
end
