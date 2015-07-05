class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :type
      t.decimal :balance , :scale => 10, :precision => 15
      t.text :description

      t.timestamps
    end
  end
end
