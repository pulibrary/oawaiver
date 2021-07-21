class RenameAuthorsToEmployees < ActiveRecord::Migration
  def change
    rename_table :authors, :employees
  end
end
