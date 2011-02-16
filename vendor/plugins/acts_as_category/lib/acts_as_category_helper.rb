
# Gosh, this poor helper needs some major refactoring :)

module ActsAsCategoryHelper
  
  extend ActiveSupport::Memoizable
  
  # --------------------------
  # Select box with categories
  # --------------------------
  
  def aac_select(roots, options = {})
    config = {:id => 'category_select', :name => 'category', :class => 'category_select', :selected => '', :parents_nil => false, :option_all => false, :option_nil => false}
    config.update(options) if options.is_a?(Hash)
    result = "<select id='#{config[:id]}' name='#{config[:name].to_s}' class='#{config[:class]}'>"
    result += "<option value=''    #{"selected='selected'" if config[:selected] == '' }   >#{config[:option_nil]}</option>" unless config[:option_nil] == false
    result += "<option value='all' #{"selected='selected'" if config[:selected] == 'all' }>#{config[:option_all]}</option>" unless config[:option_all] == false
    roots.each { |root| result += aac_select_option(root, config[:selected], config[:parents_nil]) }
    result += '</select>'
  end
  memoize :aac_select
  
  def aac_select_option(category, selected = '', parents_have_no_id = false)
    id = (!category.children.empty? and parents_have_no_id) ? '' : category.id
    result = "<option value='#{id}' #{"selected='selected'" if category.id == selected }>"
    result += '&nbsp;' * 4 * category.ancestors.size
    result += h(category.name)
    result += "</option>"
    unless category.children.empty? then
      category.children.each { |child| result += aac_select_option(child, selected, parents_have_no_id) }
    end
    result
  end
  private :aac_select_option
  
  # -----------------
  # Sidebar menu tree
  # -----------------
  
  def aac_tree(roots)
    result = "<ul class='tree_root'>"
    roots.each { |root| result += aac_tree_category(root) }
    result += '</ul>'
  end
  memoize :aac_tree
  
  def aac_tree_category(category)
    anchor = "aac_tree_#{category.id.to_s}"
    if category.ancestors_count == 0
      # CSS for root categories
      html_headline = ' class="tree_headline" ' 
      html_count = ''
    else
      # CSS for any deeper level of categories
      html_headline = '' 
      html_count = ' <span class="tree_count"> ' + h(category.pictures_count.to_s)+ '</span>'
    end

    result = tag('a', {:name => anchor}) + tag('/a')
    result += "<li#{html_headline}>"
    result += '<b>' if @category == category.id
    if category.pictures_count == 0 and category.ancestors_count > 0 and category.children_count == 0 then
      result += h(category.name)
    elsif category.ancestors_count == 0 or !category.children_count.blank? and category.children_count > 0 then
      result += content_tag('a', h(category.name), :onclick => "new Element.toggle('#{anchor}')", :href => "\##{anchor}")
    else
      result += link_to_unless_current h(category.name), {:controller => 'category', :id => category.id } unless category.ancestors_count == 0
    end
    result += '</b>' if @category == category.id
    result += html_count if !category.pictures_count.blank? and category.pictures_count > 0
    result += '</li>'

    if !category.children_count.blank? and category.children_count > 0
      addon = (category.ancestors_count == 0 or category.descendants_ids.include?(@category) or (category.self_and_siblings_ids.include?(@category) and category.children_count == 0)) ? '' : ' style="display: none;"'
      result += "<ul id='#{anchor}' #{addon}>"
      category.children.each { |child| result += aac_tree_category(child) }
      result += '</ul>'
    end
    result
  end
  private :aac_tree_category
  
  # --------------------------
  # Rights administration tree
  # --------------------------
  
  def aac_rights_tree(all_categories, options = {})
    config = {:matrix => false, :url => {}, :update => 'tree_rights_remote', :deactivate_links => false}
    config.update(options) if options.is_a?(Hash)
    roots = all_categories.map {|c| c unless c.parent}.compact
    result = "<span class='tree_rights'>"
    result += "<ul class='tree_root'>"
    roots.each { |root| result += aac_rights_category(root, all_categories, config) }
    result += '</ul>'
    result += '</span>'
  end
  
  def aac_rights_category(category, all_categories, config)
    children = all_categories.map {|c| c if c.parent == category}.compact
    result = '&nbsp;' * category.ancestors_count * 3
    if !category.hidden and category.permitted? then
      style = 'right_normal'
      result += "<span class='#{style}'>#{category.name}</span>"
    elsif category.permitted?
      style = 'color: #0b0;'
      result += config[:deactivate_links] ? "<span style='#{style}'>#{category.name}</span>" : link_to_remote(category.name, {:update => config[:update], :url => config[:url].update({:deny => category.id, :allow => nil})}, {:style => style})
    else
      style = 'color: #c00;'
      if category.hidden then
        result += config[:deactivate_links] ? "<span style='#{style}'>#{category.name}</span>" : link_to_remote(category.name, {:update => config[:update], :url => config[:url].update({:allow => category.id, :deny => nil})}, {:style => style})
      else
        result += "<span style='#{style}'>#{category.name}</span>"
      end
    end
    result += '<br/>'
    unless children.empty? then
      children.each { |child| result += aac_rights_category(child, all_categories, config) }
    end
    result
  end
  private :aac_rights_category
  
  # ----------------------------
  # Position administration tree
  # ----------------------------
    
  def aac_sortable_tree(model, options = {})
    raise "Model '#{model.to_s}' does not acts_as_category" unless model.respond_to?(:acts_as_category)
    config = {:url => {:controller => :funkenadmin, :action => :categories}, :column => 'name', :edit_url => {:controller => :funkenadmin, :action => :categories}, :edit_link => '-o-'}
    config.update(options) if options.is_a?(Hash)
    result = '<div id="aac_sortable_tree_response">'
    model.roots.each { |root| result += aac_sortable_tree_list(root, config[:url], config[:column], config[:edit_url], config[:edit_link]) }
    result += '</div>'
  end

  def aac_sortable_tree_list(category, ajaxurl, column = 'name', edit_url = '', edit_link = '')
    parent_id = category.parent ? category.parent.id.to_s : '0'
    firstitem = category.read_attribute(category.position_column) == 1
    lastitem = category.position == category.self_and_siblings.size
    result = ''
    result += "<ul id=\"aac_sortable_tree_#{parent_id}\">\n" if firstitem
    result += "<li id=\"category_#{category.id}\">#{category.read_attribute(column)}"
    result += " " + link_to(edit_link, edit_url.update({:id => category.id})) unless edit_url.blank?
    result += category.children.empty? ? "</li>\n" : "\n"
    category.children.each {|child| result += aac_sortable_tree_list(child, ajaxurl, column, edit_url, edit_link) } unless category.children.empty?
    result += "</ul></li>\n" + sortable_element("aac_sortable_tree_#{parent_id}", :update => 'aac_sortable_tree_response', :url => ajaxurl) + "\n\n" if lastitem
    result
  end
  private :aac_sortable_tree_list

end
