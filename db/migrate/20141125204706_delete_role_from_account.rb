class DeleteRoleFromAccount < ActiveRecord::Migration
  def up
    remove_column :accounts, :role
  end
  def down
    add_column :accounts, :role, :string
    Account.all.each do |account|
      account.role = "admin"
      account.save
    end
  end
end
