class AddFirstCategory < ActiveRecord::Migration
  def self.up
    firstcat = Category.first
    if firstcat.blank?
      Category.create :name => "General"
    end
  end

  def self.down
    cat = Category.find(:first, :conditions => [ "name = ?", "General"])
    cat.destroy unless cat.nil?
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)