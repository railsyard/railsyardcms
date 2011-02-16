class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.string    :name
      t.text      :desc
      t.string    :type
      t.timestamps
    end
  end

  def self.down
    drop_table :snippets
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)