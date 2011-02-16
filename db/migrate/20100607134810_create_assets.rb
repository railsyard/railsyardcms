class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :source_content_type
      t.string :source_file_name
      t.integer :source_file_size
      t.datetime :source_updated_at
      t.string :type
      t.integer :attachable_id
      t.string :attachable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)