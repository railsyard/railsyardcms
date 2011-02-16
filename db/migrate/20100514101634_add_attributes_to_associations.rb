class AddAttributesToAssociations < ActiveRecord::Migration
  def self.up
    add_column :associations, :article_id, :integer
    add_column :associations, :category_id, :integer
    add_column :associations, :tag_id, :integer
  end

  def self.down
    remove_column :associations, :tag_id
    remove_column :associations, :category_id
    remove_column :associations, :article_id
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)