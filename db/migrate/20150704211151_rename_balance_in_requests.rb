class RenameBalanceInRequests < ActiveRecord::Migration
  def change
    rename_column :requests,:balance,:amount
  end
end
