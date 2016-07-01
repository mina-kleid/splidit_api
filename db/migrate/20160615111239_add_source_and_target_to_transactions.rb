class AddSourceAndTargetToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :source, index: true
    add_reference :transactions, :target, index: true
  end
end
