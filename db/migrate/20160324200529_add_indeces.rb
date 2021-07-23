# frozen_string_literal: true

class AddIndeces < ActiveRecord::Migration
  def change
    add_index :employees, :unique_id
    add_index :waiver_infos, :author_email
    add_index :waiver_infos, :requester_email
  end
end
