class AddReservedToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :reserved, :boolean
  end

  def self.down
    remove_column :pages, :reserved
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)