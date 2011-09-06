module Admin::AdminHelper
  
  def admin_menus
    result = ""
    Ry::Plugin::Manager.instance.plugins.each do |plugin|
      result += render plugin.admin_menu if plugin.admin_menu
    end
    result.html_safe
  end
  
  def page_tree(root)
    out = ""
    if root && !root.children.blank?
      out << "<ol class='sortable'>\n"
      root.children.map do |c|
        out << page_tree_node(c)
      end
      out << "</ol>\n"
      out << page_tree_script
    elsif root && root.children.blank?
      out << "<p>Pages tree empty.</p>"
    else
      out << "<p>Root page missing.</p>"
    end  
    out.hs
  end
  

     
  def set_class(options = {})
    out = ""
    out << "#{options[:class]}" if options.has_key?(:class)
    out << " this_controller" if options.has_key?(:controller) && options[:controller].include?(controller.controller_name)
    out << " this_action" if options.has_key?(:controller) && options[:controller].include?(controller.controller_name) && options.has_key?(:action) && options[:action].include?(controller.action_name)
    out.blank? ? "" : "class=\'#{out}\'"
  end
  
  
  def set_class2(controller_name, controller_action = "", classes = "")
    
    out = "class=\'"
    # se il controller corrisponde
    out << " this_controller" if controller.controller_name.eql?(controller_name)
    
    # se l'action corrisponde
    out << " this_action" if controller.action_name.eql?(controller_action)
    
    out << " #{classes}\'"
  end
  
  private
  
  def page_tree_node(node, indentation="")
    indent = "#{indentation}    "
    out = "#{indent}<li id='page-#{node.id}'><div>#{node.title} #{link_to t('admin.general.properties'), edit_admin_page_path(node.id)} #{link_to t('admin.general.contents'), admin_page_path(node.id)}</div>\n" # Ending </li> removed intentionally 
    if !node.children.blank?
      node.children.map do |c|
        out << "#{indent}<ol>\n"
        out << page_tree_node(c, indent)
        out << "#{indent}</ol>\n"
      end
    end
    out
  end
  
  def page_tree_script
    out = "
      <script type='text/javascript'>

        	$(document).ready(function(){

        		$('ol.sortable').nestedSortable({
        			disableNesting: 'no-nest',
        			forcePlaceholderSize: true,
        			handle: 'div',
        			helper:	'clone',
        			items: 'li',
        			opacity: .6,
        			placeholder: 'placeholder',
        			tabSize: 25,
        			tolerance: 'pointer',
        			toleranceElement: '> div'
        		});

        		$('#serialize').click(function(){
        			serialized = $('ol.sortable').nestedSortable('serialize');
        			$('#serializeOutput').text(serialized);
        		})	
        		
        	})
      </script>
    "
    out.hs
  end
  
end
