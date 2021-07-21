# frozen_string_literal: true

class RenameAuthorsToEmployees < ActiveRecord::Migration
  def change
    rename_table :authors, :employees
  end
end
