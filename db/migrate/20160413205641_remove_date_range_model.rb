# frozen_string_literal: true

class RemoveDateRangeModel < ActiveRecord::Migration[5.2]
  def up
    drop_table 'date_ranges'
    add_column :employees, :department, :string
  end

  def down
    create_table 'date_ranges', force: :cascade do |t|
      t.date     'stop'
      t.date     'start'
      t.integer  'employee_id', limit: 4
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string   'department', limit: 255
    end

    remove_column :employees, :department
  end
end
