class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :owner, polymorphic: true, index: true
      t.decimal :balance, :scale => 10, :precision => 15, default: 0

      t.timestamps null: false
    end
  end
end
