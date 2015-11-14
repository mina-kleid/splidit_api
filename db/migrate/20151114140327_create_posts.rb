class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true
      t.references :target,:polymorphic => true,:index => true
      t.string :text
      t.integer :post_type

      t.timestamps null: false
    end
    add_foreign_key :posts, :users
  end
end
