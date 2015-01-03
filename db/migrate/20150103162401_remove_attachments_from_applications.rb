class RemoveAttachmentsFromApplications < ActiveRecord::Migration
  def change
    remove_column :applications, :attachments, :string
  end
end
