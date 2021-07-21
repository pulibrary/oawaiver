# frozen_string_literal: true

class NotesFieldAsText < ActiveRecord::Migration
  def up
    change_column :waiver_infos, :notes, :text
    change_column :waiver_infos, :title, :string, limit: 512
  end

  def down
    change_column :waiver_infos, :notes, :string
  end
end
