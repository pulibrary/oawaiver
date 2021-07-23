# frozen_string_literal: true

class ForceUniqueIdToString < ActiveRecord::Migration
  def up
    change_column :employees, :unique_id, :string
  end

  def down
    change_column :employees, :unique_id, :integer
  end
end
