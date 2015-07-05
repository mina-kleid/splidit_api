class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :author, polymorphic: true, index: true
      t.integer :type
      t.text :content

      t.timestamps
    end
  end
end
