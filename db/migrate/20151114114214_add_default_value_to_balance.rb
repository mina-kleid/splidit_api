class AddDefaultValueToBalance < ActiveRecord::Migration
  def change
    change_column :users, :balance, :decimal, :scale => 10, :precision => 15, :default => 0
    change_column :groups, :balance, :decimal, :scale => 10, :precision => 15, :default => 0
  end
end
