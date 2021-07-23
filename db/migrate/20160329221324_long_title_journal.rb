# frozen_string_literal: true

class LongTitleJournal < ActiveRecord::Migration
  def up
    change_column :waiver_infos, :title, :string, limit: 512
    change_column :waiver_infos, :journal, :string, limit: 512
  end

  def down
    change_column :waiver_infos, :title, :string, limit: 255
    change_column :waiver_infos, :journal, :string, limit: 255
  end
end
