class AddCommentEnabledToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :comments_enabled, :boolean
    add_column :settings, :comments_enabled_default, :boolean, :default => true
    
    Article.all.map do |a|
      a.update_attribute :comments_enabled, true
    end
  end

  def self.down
    remove_column :settings, :comments_enabled_default
    remove_column :articles, :comments_enabled
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)