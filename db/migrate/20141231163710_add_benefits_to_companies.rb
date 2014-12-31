class AddBenefitsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :benefits, :text
  end
end
