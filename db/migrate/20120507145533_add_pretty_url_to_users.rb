class AddPrettyUrlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :pretty_url, :string
    User.all.each do |u|
      pretty_url = "#{u.firstname}-#{u.lastname}".urlify
      u.update_attribute(:pretty_url, pretty_url)
    end
  end

  def self.down
    remove_column :users, :pretty_url
  end
end
