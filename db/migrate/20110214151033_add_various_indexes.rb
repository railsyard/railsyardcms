class AddVariousIndexes < ActiveRecord::Migration
  def self.up
    add_index :associations, :page_id
    add_index :associations, :snippet_id
    add_index :categorizations, :article_id
    add_index :categorizations, :category_id
    add_index :categorizations, :tag_id
    add_index :categorizations, :snippet_id
  end

  def self.down
    remove_index :associations, :page_id
    remove_index :associations, :snippet_id
    remove_index :categorizations, :article_id
    remove_index :categorizations, :category_id
    remove_index :categorizations, :tag_id
    remove_index :categorizations, :snippet_id
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)