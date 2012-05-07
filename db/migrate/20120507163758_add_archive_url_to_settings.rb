class AddArchiveUrlToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :archive_url, :string
  end
end
