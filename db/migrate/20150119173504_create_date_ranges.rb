# frozen_string_literal: true

class CreateDateRanges < ActiveRecord::Migration
  def change
    create_table :date_ranges do |t|
      t.date :to
      t.date :from
      t.references :employee
      t.timestamps
    end
  end
end
