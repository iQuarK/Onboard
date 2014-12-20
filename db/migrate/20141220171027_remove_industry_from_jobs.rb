class RemoveIndustryFromJobs < ActiveRecord::Migration
  def change
  	remove_column :jobs, :industry
  end
end
