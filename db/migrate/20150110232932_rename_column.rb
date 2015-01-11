class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :companies, :is_account_current, :expired
    change_column :companies, :expired, :boolean, default: false
  end
end
