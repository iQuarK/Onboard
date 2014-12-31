class AddStripeFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :is_account_current, :boolean, default: false
  end
end
