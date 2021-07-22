# frozen_string_literal: true

class AddNotesToWaiverInfo < ActiveRecord::Migration[5.2]
  def up
    add_column :waiver_infos, :notes, :string
  end

  def down
    remove_column :waiver_infos, :notes
  end
end
