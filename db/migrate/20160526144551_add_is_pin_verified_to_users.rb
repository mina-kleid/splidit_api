class AddIsPinVerifiedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_pin_verified, :boolean, default: false
  end
end
