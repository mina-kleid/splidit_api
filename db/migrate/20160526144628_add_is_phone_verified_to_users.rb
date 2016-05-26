class AddIsPhoneVerifiedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_phone_verified, :boolean, default: false
  end
end
