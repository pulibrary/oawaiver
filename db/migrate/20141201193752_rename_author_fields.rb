# frozen_string_literal: true

class RenameAuthorFields < ActiveRecord::Migration
  def change
    rename_column :authors, :firstName, :first_name
    rename_column :authors, :lastName, :last_name
    rename_column :authors, :preferredName, :preferred_name
    rename_column :authors, :uniqueId, :unique_id
  end
end
