# frozen_string_literal: true

class RenameAuthorsToEmployees < ActiveRecord::Migration[5.2]
  def change
    rename_table :authors, :employees
  end
end
