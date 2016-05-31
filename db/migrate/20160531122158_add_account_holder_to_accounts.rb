class AddAccountHolderToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :account_holder, :string
  end
end
