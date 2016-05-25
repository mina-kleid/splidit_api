class AddAccountNumberAndBlzToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :account_number, :string
    add_column :accounts, :blz, :string
  end
end
