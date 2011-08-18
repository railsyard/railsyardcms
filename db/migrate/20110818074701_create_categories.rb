class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end
    
    Category.create :name => "General"
    Category.create :name => "Nerdy stuff"
  end

  def self.down
    drop_table :categories
  end
end
