class ChangeAccountsToBankAccounts < ActiveRecord::Migration
  def change
    rename_table :accounts, :bank_accounts
  end
end
