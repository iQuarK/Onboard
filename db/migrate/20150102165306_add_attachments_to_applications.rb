class AddAttachmentsToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :attachments, :text
  end
end
