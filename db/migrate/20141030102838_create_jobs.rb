class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.string :location
      t.boolean :remote
      t.string :industry
      t.string :job_type

      t.timestamps
    end
  end
end
