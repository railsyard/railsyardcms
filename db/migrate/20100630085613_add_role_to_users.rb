class AddRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :roles_mask, :integer
    remove_column :users, :role
  end

  def self.down
    remove_column :users, :roles_mask
    add_column :users, :role, :integer
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)