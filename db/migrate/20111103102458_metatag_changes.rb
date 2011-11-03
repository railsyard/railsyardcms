class MetatagChanges < ActiveRecord::Migration
  def self.up
    remove_column :settings, :site_name
    remove_column :settings, :site_base_url
    remove_column :settings, :homepage_id
    rename_column :settings, :site_keywords, :default_page_keywords
    rename_column :settings, :site_desc, :default_page_desc
    change_column :settings, :site_page_title, :string, :default => "My new RailsYard site"
    
    settings = Setting.first
    settings.update_attribute(:site_page_title, "My new RailsYard site") if settings.site_page_title.blank?
  end

  def self.down
    change_column :settings, :site_page_title, :string
    rename_column :settings, :default_page_desc, :site_desc
    rename_column :settings, :default_page_keywords, :site_keywords
    add_column :settings, :homepage_id, :integer, :default => 1
    add_column :settings, :site_base_url, :string,     :default => "localhost:3000"
    add_column :settings, :site_name, :string, :default => "My new RailsYard site"
  end
end
