# frozen_string_literal: true

json.call(@waiver_infos, :current_page, :per_page, :total_entries)

json.waiver_infos @waiver_infos do |waiver_info|
  json.call(waiver_info,  :id, :requester, :requester_email)
  json.call(waiver_info,  :author_unique_id, :author_first_name, :author_last_name, :author_status, :author_department,
            :author_email)
  json.call(waiver_info,  :title, :journal, :journal_issn)
  json.url url_for(waiver_info)
end
