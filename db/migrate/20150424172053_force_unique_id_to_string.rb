# frozen_string_literal: true

class ForceUniqueIdToString < ActiveRecord::Migration[5.2]
  def up
    change_column :employees, :unique_id, :string
  end

  def down
    change_column :employees, :unique_id, :integer
  end
end
