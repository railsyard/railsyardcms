# This file should contain all the record creation needed to seed the database with its default values.
# This will import some contents into the db just to have some example

public

def generate_page(parent, title, pretty_url, the_layout)
  pg = parent.children.create :parent => parent, :title => title, :pretty_url => "#{pretty_url}#{"-"+parent.lang if parent.lang!='en'}", :lang => parent.lang, :visible_in_menu => true, :reserved => false, :published => true, :layout_name => the_layout, :publish_at => Time.now, :meta_title => title, :meta_description => title
  pg.snippets.create :title => "Two levels menu", :area => "header", :cell_controller => "menu", :cell_action => "two_levels", :handler => "menu%two_levels%#{rand(99999).to_s.center(5, rand(9).to_s)}"
  pg.snippets.create :title => "Footer menu", :area => "footer", :cell_controller => "menu", :cell_action => "footer", :handler => "menu%footer%#{rand(99999).to_s.center(5, rand(9).to_s)}"
  if the_layout == "two_columns.html.erb" or the_layout == "three_columns.html.erb"
      pg.snippets.create :title => "Siblings menu", :area => "left", :cell_controller => "menu", :cell_action => "siblings", :handler => "menu%siblings%#{rand(99999).to_s.center(5, rand(9).to_s)}"      
  end  
  pg
end

private
# Creating pages
single_column = "single_column.html.erb"
two_columns =   "two_columns.html.erb"
three_columns = "three_columns.html.erb"

Setting.first.update_attribute(:theme_name, "rough") # does not work if called from rake ry:init task

Page.all.map do |p|
  p.snippets.map{|s| s.update_attribute(:area, "limbo")}
  p.update_attribute(:layout_name, single_column)
end


Language.all.each do |lang|
  root = Page.find_by_title(lang.short)
  # Adding some snippets to home pages
  home = root.children.first
  home.snippets.create :title => "Two levels menu", :area => "header", :cell_controller => "menu", :cell_action => "two_levels", :handler => "menu%two_levels%#{rand(99999).to_s.center(5, rand(9).to_s)}"
  home.snippets.create :title => "Footer menu", :area => "footer", :cell_controller => "menu", :cell_action => "footer", :handler => "menu%footer%#{rand(99999).to_s.center(5, rand(9).to_s)}"
  
  # Generating new pages
  first = generate_page(root, "First Group", "first", single_column)
  generate_page(first, "1st page", "sub-first", single_column)
  generate_page(first, "2nd page", "sub-second", two_columns)
  generate_page(first, "3d page", "sub-third", three_columns)
  puts "Generated first group of pages for language \"#{lang.name}\""
    
  second = generate_page(root, "Second Group", "second", single_column)
  generate_page(second, "4th page", "sub-fourth", single_column)
  generate_page(second, "5th page", "sub-fifth", two_columns)
  generate_page(second, "6th page", "sub-sixth", three_columns)
  puts "Generated second group of pages for language \"#{lang.name}\""
end


