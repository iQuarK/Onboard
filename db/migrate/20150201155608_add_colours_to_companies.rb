class AddColoursToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :background_colour, :string
    add_column :companies, :header_colour, :string
  end
end
