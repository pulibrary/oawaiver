class CreateAuthors < ActiveRecord::Migration
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
