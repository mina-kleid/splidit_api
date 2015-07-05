class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :sender, polymorphic: true, index: true
      t.references :receiver, polymorphic: true, index: true
      t.decimal :amount, :scale => 10, :precision => 15

      t.timestamps
    end
  end
end
