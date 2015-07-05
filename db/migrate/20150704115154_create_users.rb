class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :secret
      t.string :key
      t.decimal :balance , :scale => 10, :precision => 15

      t.timestamps
    end
  end
end
