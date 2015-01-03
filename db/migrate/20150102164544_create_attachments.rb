class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.belongs_to :attachable, polymorphic: true
      t.string :attachment
      t.timestamps
    end
  end
end
