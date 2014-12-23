class AddLinkedInStuffToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :linkedin_token, :string
    add_column :applications, :linkedin_secret, :string
  end
end
