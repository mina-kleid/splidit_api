class ModifyUsers < ActiveRecord::Migration
  def change
    add_column :users,:phone,:string unless column_exists?(:users,:phone)
    add_column :users,:encrypted_password,:string unless column_exists?(:users,:encrypted_password)
    add_column :users,:salt,:string unless column_exists?(:users,:salt)
    add_column :users,:authentication_token,:string unless column_exists?(:users,:authentication_token)
  end
end
