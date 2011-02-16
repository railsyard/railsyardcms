class CreateLayouts < ActiveRecord::Migration
  def self.up
    create_table :layouts do |t|
      t.column :name, :string
      t.column :template_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :layouts
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)