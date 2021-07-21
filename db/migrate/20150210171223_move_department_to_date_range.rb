# frozen_string_literal: true

class MoveDepartmentToDateRange < ActiveRecord::Migration
  def change
    add_column :date_ranges, :department, :string
    remove_column :employees, :department
  end
end
