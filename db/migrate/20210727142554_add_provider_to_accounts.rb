class AddProviderToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :provider, :string, null: false, default: "cas"
    add_index :accounts, :provider
  end
end
