class AddIsAdminToUsersGroups < ActiveRecord::Migration
  def change
    add_column :user_groups, :is_admin, :boolean
  end
end
