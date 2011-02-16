class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :name
      t.timestamps
    end
    
    add_column :associations, :template_id, :integer
  end

  def self.down
    remove_column :associations, :template_id
    drop_table :templates
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)