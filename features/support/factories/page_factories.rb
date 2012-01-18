Factory.define :page do |page|
  page.lang 'en'
  page.layout_name 'single_column.html.erb'
  page.reserved false
  page.visible_in_menu true
  page.published true
  page.parent_id 3
  page.pretty_url { Factory.next(:pretty_url) }
  page.publish_at Time.new
  #page.position (Page.order("position ASC").last.try(:position) || 1) #not working with postgres
  page.position {
    last_pos = Page.order("position ASC").last.try(:position)
    last_pos.to_i+1
  }
  
end

Factory.define :language_page, :class => Page do |page|
  page.title 'en'
  page.pretty_url 'en'
  page.lang 'en'
end

Factory.sequence :pretty_url do |n|
  "page-#{n}"
end

Factory.define :snippet do |snippet|
end

Factory.define :paste do |assoc|
  assoc.position(Paste.order('position ASC').last.try(:position)||1)
end