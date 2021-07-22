# frozen_string_literal: true

class LongEmailBlob < ActiveRecord::Migration[5.2]
  def up
    change_column :mail_records, :body, :text
    change_column :mail_records, :blob, :text
  end

  def down
    change_column :mail_records, :body, :string
    change_column :mail_records, :blob, :string
  end
end
