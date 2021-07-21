# frozen_string_literal: true

class CreateMailRecords < ActiveRecord::Migration
  def change
    create_table :mail_records do |t|
      t.belongs_to :waiver_info

      t.string :blob
      t.string :to
      t.string :cc
      t.string :bcc
      t.string :subject
      t.string :body
      t.string :mime_type
      t.string :message_id
      t.string :date
    end
  end
end
