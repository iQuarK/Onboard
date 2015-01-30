class CreateTempFiles < ActiveRecord::Migration
  def change
    create_table :temp_files do |t|
      t.string :file

      t.timestamps
    end
  end
end
