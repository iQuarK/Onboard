class AddRequirementsAndBenefitsToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :requirements, :text
  	add_column :jobs, :benefits, :text
  end
end
