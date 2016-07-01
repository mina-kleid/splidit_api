class ChangeTransactionModel < ActiveRecord::Migration
  def change
    remove_reference :transactions, :source, polymorphic: true, index: true
    remove_reference :transactions, :target, polymorphic: true, index: true
  end
end
