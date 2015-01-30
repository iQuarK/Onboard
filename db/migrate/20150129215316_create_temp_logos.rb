class CreateTempLogos < ActiveRecord::Migration
  def change
    create_table :temp_logos do |t|
      t.string :logo

      t.timestamps
    end
  end
end
