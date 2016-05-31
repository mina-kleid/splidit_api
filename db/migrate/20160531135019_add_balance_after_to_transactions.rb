class AddBalanceAfterToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :balance_after, :decimal, :scale => 10, :precision => 15
    rename_column :transactions, :balance, :balance_before
  end
end
