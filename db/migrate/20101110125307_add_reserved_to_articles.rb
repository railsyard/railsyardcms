class AddReservedToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :reserved, :boolean
    
    Article.all.map do |a|
      a.update_attribute :reserved, false
    end
  end

  def self.down
    remove_column :articles, :reserved
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)