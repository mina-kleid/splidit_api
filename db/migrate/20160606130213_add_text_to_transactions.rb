class AddTextToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :text, :string
  end
end
