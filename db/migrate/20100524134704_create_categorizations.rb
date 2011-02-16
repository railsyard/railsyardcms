class CreateCategorizations < ActiveRecord::Migration
  def self.up
    create_table :categorizations do |t|
      t.column :article_id, :integer
      t.column :category_id, :integer
      t.column :tag_id, :integer
      t.timestamps
    end
    remove_column :associations, :tag_id
    remove_column :associations, :category_id
    remove_column :associations, :article_id
  end

  def self.down
    drop_table :categorizations
    add_column :associations, :article_id, :integer
    add_column :associations, :category_id, :integer
    add_column :associations, :tag_id, :integer
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)