# Author::    Silvio Relli  (mailto:silvio@relli.org)

class AddUserIdToManyModels < ActiveRecord::Migration
  def self.up
    add_column :pages, :user_id, :integer
    add_column :articles, :user_id, :integer
    add_column :associations, :user_id, :integer
  end

  def self.down
    remove_column :associations, :user_id
    remove_column :articles, :user_id
    remove_column :pages, :user_id
  end
end
