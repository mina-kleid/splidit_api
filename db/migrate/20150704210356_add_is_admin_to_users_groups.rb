class AddIsAdminToUsersGroups < ActiveRecord::Migration
  def change
    add_column :users_groups, :is_admin, :boolean
  end
end
