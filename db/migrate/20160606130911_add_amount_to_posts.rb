class AddAmountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :amount, :decimal, precision: 15, scale: 10
  end
end
