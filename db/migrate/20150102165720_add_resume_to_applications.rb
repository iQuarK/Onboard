class AddResumeToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :resume, :string
  end
end
