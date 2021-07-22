# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :authors do |t|
      t.string :firstName
      t.string :lastName
      t.string :preferredName
      t.string :uniqueId
      t.string :email
      t.string :netid

      t.timestamps
    end
  end
end
