class AddPublishedToComments < ActiveRecord::Migration
  def change
    add_column :comments, :published, :boolean

  end
end
