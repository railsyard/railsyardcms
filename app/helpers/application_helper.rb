# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  #receives language symbol (en, it..) and returns full name (English, Italiano...)
  def language_symbol_to_full(symbol)
    Language.find(symbol.to_s).name
  end
  
  # Clippy helper for copying a text into clipboard
  def clippy(text, bgcolor='#FFFFFF')
    html = <<-EOF
      <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
              width="110"
              height="14"
              id="clippy" >
      <param name="movie" value="/flash/clippy.swf"/>
      <param name="allowScriptAccess" value="always" />
      <param name="quality" value="high" />
      <param name="scale" value="noscale" />
      <param NAME="FlashVars" value="text=#{text}">
      <param name="bgcolor" value="#{bgcolor}">
      <embed src="/flash/clippy.swf"
             width="110"
             height="14"
             name="clippy"
             quality="high"
             allowScriptAccess="always"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer"
             FlashVars="text=#{text}"
             bgcolor="#{bgcolor}"
      />
      </object>
    EOF
    html.hs
  end
  
  # def create_asset_path_authenticated
  #   session_key = ActionController::Base.session_options[:key]
  #   assets_path(session_key => cookies[session_key], request_forgery_protection_token => form_authenticity_token)
  # end
  
  def create_admin_asset_path_authenticated
    session_key = ActionController::Base.session_options[:key]
    admin_assets_path(session_key => cookies[session_key], request_forgery_protection_token => form_authenticity_token)
  end
  
  #modified version of acts_at_category, see vendor/plugins/acts_as_category/lib/acts_as_category_helper.rb
  def page_tree(model, lang, options = {})
    raise "Model '#{model.to_s}' does not acts_as_category" unless model.respond_to?(:acts_as_category)
    config = {:url => {:controller => "admin/pages", :action => :update_positions}, :column => 'name', :edit_url => {:controller => "admin/pages", :action => :edit}, :edit_link => "<span class='invisible'>Properties</span>".hs, :show_url => {:controller => "admin/pages", :action => :show}, :show_link => "<span class='invisible'>Contents</span>".hs}
    config.update(options) if options.is_a?(Hash)
    result = '<div id="aac_sortable_tree_response">'
    model.roots.find(:all, :conditions => ["lang = ?", lang]).each { |root| result += page_tree_list(root, config[:url], config[:column], config[:edit_url], config[:edit_link], config[:show_url], config[:show_link]) }
    result += '</div>'
    result.hs
  end
  
  def yard_aac_select(model, lang, options = {})
    config = {:id => 'category_select', :name => 'category', :class => 'category_select', :selected => '', :parents_nil => false, :option_all => false, :option_nil => false}
    config.update(options) if options.is_a?(Hash)
    result = "<select id='#{config[:id]}' name='#{config[:name].to_s}' class='#{config[:class]}'>"
    result += "<option value=''    #{"selected='selected'" if config[:selected] == '' }   >#{config[:option_nil]}</option>" unless config[:option_nil] == false
    result += "<option value='all' #{"selected='selected'" if config[:selected] == 'all' }>#{config[:option_all]}</option>" unless config[:option_all] == false
    model.roots.find(:all, :conditions => ["lang = ?", lang]).each { |root| result += aac_select_option(root, config[:selected], config[:parents_nil]) }
    result += '</select>'
    result.hs
  end

  private
  
  def page_tree_list(category, ajaxurl, column = 'name', edit_url = '', edit_link = '', show_url='', show_link='')
    parent_id = category.parent ? category.parent.id.to_s : '0'
    ordered_siblings = category.self_and_siblings.for_language(category.lang).sort{|x,y| x.position <=> y.position}
    firstitem = ordered_siblings.first == category
    lastitem = ordered_siblings.last == category
    
    result = ''
    result += "<ul id=\"aac_sortable_tree_#{parent_id}\">\n" if firstitem
    result += "<li id=\"category_#{category.id}\" style=\"cursor: move\"><strong>#{category.read_attribute(column)}</strong>"
    result += " " + link_to(show_link, show_url.update({:id => category.id}), :class => 'icon-content') unless show_url.blank?
    result += " " + link_to(edit_link, edit_url.update({:id => category.id}), :class => 'icon-properties') unless edit_url.blank?
    result += category.children.empty? ? "</li>\n" : "\n"
    category.children.each {|child| result += page_tree_list(child, ajaxurl, column, edit_url, edit_link, show_url, show_link) } unless category.children.empty?
    result += "</ul></li>\n" + sortable_element("aac_sortable_tree_#{parent_id}", :url => ajaxurl, :complete => visual_effect(:highlight, "aac_sortable_tree_#{parent_id}")) + "\n\n" if lastitem
    result.hs
  end
  
  def aac_select_option(category, selected = '', parents_have_no_id = false)
    id = (!category.children.empty? and parents_have_no_id) ? '' : category.id
    result = "<option value='#{id}' #{"selected='selected'" if category.id == selected }>"
    result += '&nbsp;' * 4 * category.ancestors.size
    result += h(category.name)
    result += "</option>"
    unless category.children.empty? then
      category.children.each { |child| result += aac_select_option(child, selected, parents_have_no_id) }
    end
    result.hs
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)