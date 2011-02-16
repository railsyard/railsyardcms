class DropLayoutsTable < ActiveRecord::Migration
  def self.up
    drop_table :layouts
  end

  def self.down
    create_table :layouts do |t|
      t.column :name, :string
      t.column :template_id, :integer
      t.timestamps
    end
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)