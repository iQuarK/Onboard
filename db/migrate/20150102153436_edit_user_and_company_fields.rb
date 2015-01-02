class EditUserAndCompanyFields < ActiveRecord::Migration
  def change
    remove_column :users, :stripe_customer_id
    remove_column :users, :is_account_current
    add_column :companies, :plan, :string
    add_column :companies, :stripe_customer_id, :string
    add_column :companies, :is_account_current, :boolean, default: false

  end
end
