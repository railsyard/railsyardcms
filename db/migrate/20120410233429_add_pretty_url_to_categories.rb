class AddPrettyUrlToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :pretty_url, :string
  end
end
