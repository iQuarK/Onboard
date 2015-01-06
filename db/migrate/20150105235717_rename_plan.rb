class RenamePlan < ActiveRecord::Migration
  def change
    rename_column :companies, :plan, :plan_id
  end
end
