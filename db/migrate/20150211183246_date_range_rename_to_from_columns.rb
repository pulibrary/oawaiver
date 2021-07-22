# frozen_string_literal: true

class DateRangeRenameToFromColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :date_ranges, :to, :stop
    rename_column :date_ranges, :from, :start
  end
end
