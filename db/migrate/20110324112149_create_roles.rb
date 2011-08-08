class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :name, :string
      t.timestamps
    end
    
    ["admin", "article_writer", "premium_user", "registered_user"].each do |role|
      puts "------------------------- Creating role \'#{role}\' -------------------------"
      Role.create :name => role
    end
    
  end

  def self.down
    drop_table :roles
  end
end
