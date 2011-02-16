class AddLayoutNameToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :layout_name, :string, :default => 'default'
    Page.all.map do |p|
      p.update_attribute (:layout_name, 'default')
    end
  end

  def self.down
    remove_column :pages, :layout_name
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)