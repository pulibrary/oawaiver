# frozen_string_literal: true

class AddDepartmentToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :department, :string
  end
end
