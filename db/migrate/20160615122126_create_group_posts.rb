class CreateGroupPosts < ActiveRecord::Migration
  def change
    create_table :group_posts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.string :text
      t.integer :post_type
      t.decimal :amount, :scale => 10, :precision => 15

      t.timestamps null: false
    end
  end
end
