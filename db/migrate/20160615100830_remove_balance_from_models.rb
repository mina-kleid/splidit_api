class RemoveBalanceFromModels < ActiveRecord::Migration
  def change
    remove_column :users, :balance
    remove_column :groups, :balance
  end
end
