Given /^the page is setup in basic mode$/ do
  @category_general     = Factory(:category, :name => 'General')
  @category_nerdy_stuff = Factory(:category, :name => 'Nerdy stuff')
  
  @page_en   = Factory :language_page
  @page_home = Factory :page, 
    :title      => 'Home en', 
    :pretty_url => 'home_en', 
    :parent_id  => @page_en.id
  
  @role_admin           = Factory :role, :name => 'admin'
  @role_article_writer  = Factory :role, :name => 'article_writer'
  @role_premium_user    = Factory :role, :name => 'premium_user'
  @role_registered_user = Factory :role, :name => 'registered_user'
  
  @settings = Factory :settings, :homepage_id => @page_en.id
  
  @user_admin = Factory :user, :roles => [@role_admin]
end