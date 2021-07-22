# frozen_string_literal: true

class CreateDateRanges < ActiveRecord::Migration[5.2]
  def change
    create_table :date_ranges do |t|
      t.date :to
      t.date :from
      t.references :employee
      t.timestamps
    end
  end
end
