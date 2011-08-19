module ApplicationHelper
  
  def yield_snippets(page, area)
    out = ""
    out << "<div class=\"snippets drop_target\" id=\"#{area}\">" if current_user && current_user.is_admin? && cfg.frontend_controls
    page.snippets.for_area(area).map do |snip|
      # If there is a value 'extra_class' is defined in the options, these will be assigned to the *div*
      # surrounding the snippet
      div_class = (snip.options.is_a?(Hash) && snip.options.has_key?(:div_class)) ? snip.options[:div_class] : ""
      
      # The snippet has a class *snippet*. You can give a default style to all snippets by using this class.
      # The extra_class clan be set in the backend for some snippets and can be used to give a specific file to this
      # special snipit.
      out << "<div class=\"drag_item\" id=\"#{snip.handler}\">" if current_user && current_user.is_admin? && cfg.frontend_controls
      out << "<div class=\"snippet #{div_class}\" id=\"snippet-#{snip.id}\">"
      if current_user && current_user.is_admin? && cfg.frontend_controls
        out << "<div class=\"controls\" id=\"snippet-controls-#{snip.id}\">"
        out << link_to_function("<span>#{t('admin.general.delete')}</span>".hs, "if(confirm('#{t('admin.snippets.are_you_sure_to_delete', :name => snip.title)}')) removeSnip(#{snip.id}, '#{admin_page_snippet_path(snip.page.id, snip.id, :format => :json)}')", :class => "delete")
        out << link_to("<span>#{t('admin.general.edit')}</span>".hs, edit_admin_page_snippet_path(snip.page.id, snip.id), :class => "edit")
        out << "<span class=\"title\">#{snip.title}</span>"
        out << "</div>"
      end
      out << render_cell(snip.cell_controller, snip.cell_action, :page => page, :options => snip.options, :snip_id => snip.id)
      out << "</div>"
      out << "</div>" if current_user && current_user.is_admin? && cfg.frontend_controls
    end
    out << "</div>" if current_user && current_user.is_admin? && cfg.frontend_controls
    out.hs
  end
    
  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<p>There was a problem creating the #{object.class.name.humanize.downcase}</p>\n"
        else
          html << "\t\t<p>There was a problem updating the #{object.class.name.humanize.downcase}</p>\n"
        end    
      else
        html << "<p>#{message}</p>"
      end  
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html.hs
  end
  
end
