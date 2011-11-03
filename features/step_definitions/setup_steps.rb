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

When /^I add the (.+?) snippet from the (.+?) cell to the (.+?) area at the page "([^"]*)"$/ do |snip_name, snip_controller, page_area, page_url|
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