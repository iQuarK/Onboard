class AddMoreFieldsToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :summary, :text
    add_column :applications, :phone, :string
    add_column :applications, :address, :string
  end
end
