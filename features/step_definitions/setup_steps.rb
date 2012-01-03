Given /^the page is setup in basic mode$/ do
  DatabaseCleaner.clean
  
  @category_general     = Factory(:category, :name => 'General')
  @category_nerdy_stuff = Factory(:category, :name => 'Nerdy stuff')
  
  @page_en   = Factory :language_page
  @page_home = Factory :page, 
    :title      => 'Home en', 
    :pretty_url => 'home-en', 
    :parent_id  => @page_en.id
  
  @role_admin           = Factory :role, :name => 'admin'
  @role_article_writer  = Factory :role, :name => 'article_writer'
  @role_premium_user    = Factory :role, :name => 'premium_user'
  @role_registered_user = Factory :role, :name => 'registered_user'
  
  @settings = Factory :settings
  
  @user_admin = Factory :user, :roles => [@role_admin]
end

When /^I add the (.+?) snippet from the (.+?) cell to the (.+?) area at the page with url "([^"]*)"$/ do |snip_name, snip_controller, page_area, page_url|
  page = page_for(page_url)
  assert_not_nil(page, "page for url \"#{page_url}\" not found")
  
  cell_action = snip_name.underscore.gsub(/[^a-zA-Z0-9]/, '_')
  cell_controller = snip_controller.underscore.gsub(/[^a-zA-Z0-9]/, '_')
  
  @cellnum = @cellnum.to_i+1
  @snip = Factory :snippet,
    :title => snip_name,
    :area => page_area,
    :cell_controller => cell_controller,
    :cell_action => cell_action,
    :handler => "#{cell_controller}%#{cell_action}%#{Time.new.to_i}#{@cellnum}"
    
  Factory :association,
    :page_id => page.id,
    :snippet_id => @snip.id
end

When /^I add the (.+?) snippet from the (.+?) cell to the (.+?) area at the page "([^"]*)"$/ do |snip_name, snip_controller, page_area, page_pretty_url|
  page = Page.where(:pretty_url => page_pretty_url).first
  assert_not_nil(page, "page for url \"#{page_pretty_url}\" not found")
  
  cell_action = snip_name.underscore.gsub(/[^a-zA-Z0-9]/, '_')
  cell_controller = snip_controller.underscore.gsub(/[^a-zA-Z0-9]/, '_')
  
  @cellnum = @cellnum.to_i+1
  @snip = Factory :snippet,
    :title => snip_name,
    :area => page_area,
    :cell_controller => cell_controller,
    :cell_action => cell_action,
    :handler => "#{cell_controller}%#{cell_action}%#{Time.new.to_i}#{@cellnum}"
    
  Factory :association,
    :page_id => page.id,
    :snippet_id => @snip.id
end

Given /^frontend controls are (enabled|disabled)$/ do |status|
  s = Setting.first
  s.frontend_controls = (status=='enabled')
  s.save!
end

Given /^the snippet option "([^"]*)" is set to "([^"]*)"$/ do |key, value|
  @snip.options ||= {}
  @snip.options[key] = value
  @snip.save!
end

Given /^there are some example pages$/ do
  DatabaseCleaner.clean
  
  @category_general     = Factory(:category, :name => 'General')
  @category_nerdy_stuff = Factory(:category, :name => 'Nerdy stuff')
  
  @root_en   = Factory :language_page
  @page_home = Factory :page, 
    :title      => 'Home en', 
    :pretty_url => 'home-en', 
    :parent_id  => @root_en.id,
    :position   => 1
  
  @page_second = Factory :page, 
    :title      => 'Second', 
    :pretty_url => 'second', 
    :parent_id  => @root_en.id
  
  @page_child = Factory :page, 
    :title      => 'Child', 
    :pretty_url => 'child', 
    :parent_id  => @page_second.id  
  
  @page_third = Factory :page, 
    :title      => 'Third', 
    :pretty_url => 'third', 
    :parent_id  => @root_en.id
    
  @root_it   = Factory :page,
    :title      => 'it', 
    :pretty_url => 'it',
    :lang => 'it', 
    :parent_id  => nil
    
  @page_home = Factory :page, 
    :title      => 'Benvenuto', 
    :pretty_url => 'benvenuto', 
    :parent_id  => @root_it.id,
    :lang       => 'it',
    :position   => 1
  
  @page_seconda = Factory :page, 
    :title      => 'Seconda', 
    :pretty_url => 'seconda', 
    :parent_id  => @root_it.id,
    :lang => 'it'
  
  @page_figlia = Factory :page, 
    :title      => 'Figlia', 
    :pretty_url => 'figlia', 
    :parent_id  => @page_seconda.id,
    :lang => 'it'  
  
  @page_third = Factory :page, 
    :title      => 'Terza', 
    :pretty_url => 'terza', 
    :parent_id  => @root_it.id,
    :lang => 'it'
  
  @role_admin           = Factory :role, :name => 'admin'
  @role_article_writer  = Factory :role, :name => 'article_writer'
  @role_premium_user    = Factory :role, :name => 'premium_user'
  @role_registered_user = Factory :role, :name => 'registered_user'
  
  @settings = Factory :settings
  
  @user_admin = Factory :user, :roles => [@role_admin]
end

Given /^there are some example articles$/ do
  pending
  
  @category_general     = Factory(:category, :name => 'General')
  @category_nerdy_stuff = Factory(:category, :name => 'Nerdy stuff')
  
end