class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.decimal :amount, :scale => 10, :precision => 15
      t.integer :type
      t.references :target, polymorphic: true, index: true
      t.references :source, polymorphic: true, index: true
      t.decimal :balance, :scale => 10, :precision => 15

      t.timestamps
    end
  end
end
