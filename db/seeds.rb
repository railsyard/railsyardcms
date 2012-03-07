# Pages
first_layout_view = Theme.all.first.layouts.first.view

["it", "en", "de"].each do |lang|
  puts "------------------------- Creating root language page \'#{lang}\' -------------------------"
  root = Page.create :title => lang, :pretty_url => lang, :lang => lang
  root.children.create( :title => "Home #{lang}",
                        :pretty_url => "home_#{lang}",
                        :lang => lang,
                        :visible_in_menu => true,
                        :reserved => false,
                        :published => true,
                        :layout_name => first_layout_view,
                        :publish_at => Time.now,
                        :meta_title => "Home #{lang}",
                        :meta_description => "Home #{lang}" )
end

# Roles
["admin", "article_writer", "premium_user", "registered_user"].each do |role|
  puts "------------------------- Creating role \'#{role}\' ------------------------------------"
  Role.create :name => role
end

# Users
admin_role = Role.find_by_name('admin')
user = User.create( :email => 'admin@example.com', :firstname => 'Admin', :lastname => 'Surname', :password => 'changeme', :password_confirmation => 'changeme' )
user.confirmed_at, user.lang, user.enabled = Time.now, 'en', true
user.roles << admin_role
user.save
puts "------------------------- Creating user email \'#{user.email}\', password \'changeme\'-------------------------"

# Settings
Setting.create :site_page_title => "My new RailsYard site", :default_lang => "en"

# Categories
Category.create :name => "General"
Category.create :name => "Nerdy stuff"

["it", "en", "de", "cn"].each do |lang|
  ArticleLayout.create(:layout_name => first_layout_view, :lang => lang )
end
