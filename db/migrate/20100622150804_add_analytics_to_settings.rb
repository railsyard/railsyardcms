class AddAnalyticsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :analytics, :text, :default => ""
  end

  def self.down
    remove_column :settings, :analytics
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)