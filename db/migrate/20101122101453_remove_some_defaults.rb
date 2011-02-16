class RemoveSomeDefaults < ActiveRecord::Migration
  def self.up
    change_table :pages do |t|
      t.change :published, :boolean, :default => nil
      t.change :visible_in_menu, :boolean, :default => nil
    end
    change_table :articles do |t|
      t.change :published, :boolean, :default => nil
    end
  end

  def self.down
    change_table :pages do |t|
      t.change :published, :boolean, :default => false
      t.change :visible_in_menu, :boolean, :default => true
    end
    change_table :articles do |t|
      t.change :published, :boolean, :default => false
    end
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)