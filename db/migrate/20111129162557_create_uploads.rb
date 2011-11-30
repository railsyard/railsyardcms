class CreateUploads < ActiveRecord::Migration
  def self.up
    create_table :uploads do |t|
      t.string :data_content_type
      t.string :data_file_name
      t.integer :data_file_size
      t.datetime :data_updated_at
      t.string :type
      t.integer :attachable_id
      t.string :attachable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :uploads
  end
end
