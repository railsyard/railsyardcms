class AddVariousAttributes < ActiveRecord::Migration
  def self.up
    add_column :articles, :script, :text
    add_column :articles, :deleted, :boolean, :default => false
    add_column :pages, :script, :text
    add_column :pages, :deleted, :boolean, :default => false
    add_column :snippets, :deleted, :boolean, :default => false
    add_column :snippets, :published, :boolean, :default => false
    add_column :snippets, :publish_at, :datetime
  end

  def self.down
    remove_column :snippets, :publish_at
    remove_column :snippets, :published
    remove_column :snippets, :deleted
    remove_column :pages, :deleted
    remove_column :pages, :script
    remove_column :articles, :deleted
    remove_column :articles, :script
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)