class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :sender, polymorphic: true, index: true
      t.references :receiver, polymorphic: true, index: true
      t.decimal :balance , :scale => 10, :precision => 15
      t.integer :status

      t.timestamps
    end
  end
end
