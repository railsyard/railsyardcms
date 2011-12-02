class AddExtraLinkToUpload < ActiveRecord::Migration
  def self.up
    add_column :uploads, :extra_link, :string
  end

  def self.down
    remove_column :uploads, :extra_link
  end
end
