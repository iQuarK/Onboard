class RemoveUserRolesAndRoles < ActiveRecord::Migration
  def change
    drop_table :users_roles
    drop_table :roles
  end
end
