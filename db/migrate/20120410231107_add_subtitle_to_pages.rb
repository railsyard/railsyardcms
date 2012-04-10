class AddSubtitleToPages < ActiveRecord::Migration
    def self.up
      add_column :pages, :subtitle, :string
    end

    def self.down
      remove_column :pages, :subtitle
    end
end
