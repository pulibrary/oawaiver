# frozen_string_literal: true

class AddDepartmentToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :department, :string
  end
end
