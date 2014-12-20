class AddStageToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :stage, :integer, default: 0
  end
end
