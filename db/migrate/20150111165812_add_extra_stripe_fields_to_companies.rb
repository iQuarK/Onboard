class AddExtraStripeFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :stripe_card_brand, :string, after: :stripe_customer_id
    add_column :companies, :stripe_card_last_4, :string, after: :stripe_card_brand
  end
end
