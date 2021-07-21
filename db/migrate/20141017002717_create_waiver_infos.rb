# frozen_string_literal: true

class CreateWaiverInfos < ActiveRecord::Migration
  def change
    create_table :waiver_infos do |t|
      t.string :requester
      t.string :requester_email
      t.string :author_unique_id
      t.string :author_first_name
      t.string :author_last_name
      t.string :author_status
      t.string :author_department
      t.string :author_email
      t.string :title
      t.string :journal
      t.string :journal_issn

      t.timestamps
    end
  end
end
