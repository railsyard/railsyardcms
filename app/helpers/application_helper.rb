module ApplicationHelper
  def has_frontend_controls?
    current_user && current_user.is_admin? && cfg.frontend_controls
  end
  
  def yield_snippets(page, area)
    out = ""
    out << "<div class=\"snippets drop_target\" id=\"#{area}\">" if has_frontend_controls?
    page.snippets.for_area(area).map do |snip|
      div_class = (snip.options.is_a?(Hash) && snip.options.has_key?(:div_class)) ? snip.options[:div_class] : ""      
      out << "<div class=\"drag_item\" id=\"#{snip.handler}\"><div id=\"snippet-modal-dialog-#{snip.id}\" title=\"Configuration: #{h snip.title}\"></div>" if has_frontend_controls?
      out << "<div class=\"snippet #{div_class}\" id=\"snippet-#{snip.id}\">"
      if has_frontend_controls?
        out << "<div class=\"controls\" id=\"snippet-controls-#{snip.id}\">"
        out << link_to_function("<span>#{t('admin.general.delete')}</span>".hs, "if(confirm('#{t('admin.snippets.are_you_sure_to_delete', :name => snip.title)}')) removeSnip(#{snip.id}, '#{admin_page_snippet_path(snip.page.id, snip.id, :format => :json)}')", :class => "delete")
        out << link_to_function("<span>#{t('admin.general.edit')}</span>".hs, "openDialog('#{escape_javascript(snip.title)}','#{edit_admin_page_snippet_path(snip.page.id, snip.id, :format => :dialog)}');", :class => "edit")
        out << "<span class=\"title\">#{snip.title}</span>"
        out << "</div>"
      end
      out << render_cell(snip.cell_controller, snip.cell_action, :page => page, :options => snip.options, :snip_id => snip.id, :current_user => current_user)
      out << "</div>"
      out << "<div class=\"cleanup\"></div>" if has_frontend_controls?
      out << "</div>" if has_frontend_controls?
    end
    out << "</div>" if has_frontend_controls?
    out.hs
  end
  
  def yield_article_snippets(article_layout, area, article)
    out = ""
    out << "<div class=\"snippets drop_target\" id=\"#{area}\">" if has_frontend_controls?
    article_layout.snippets.for_area(area).map do |snip|
      div_class = (snip.options.is_a?(Hash) && snip.options.has_key?(:div_class)) ? snip.options[:div_class] : ""      
      out << "<div class=\"drag_item\" id=\"#{snip.handler}\"><div id=\"snippet-modal-dialog-#{snip.id}\" title=\"Configuration: #{h snip.title}\"></div>" if has_frontend_controls?
      out << "<div class=\"snippet #{div_class}\" id=\"snippet-#{snip.id}\">"
      if current_user && current_user.is_admin? && cfg.frontend_controls
        out << "<div class=\"controls\" id=\"snippet-controls-#{snip.id}\">"
        out << link_to_function("<span>#{t('admin.general.delete')}</span>".hs, "if(confirm('#{t('admin.snippets.are_you_sure_to_delete', :name => snip.title)}')) removeSnip(#{snip.id}, '#{admin_article_layout_snippet_path(snip.article_layout.id, snip.id, :format => :json)}')", :class => "delete")
        out << link_to_function("<span>#{t('admin.general.edit')}</span>".hs, "openDialog('#{escape_javascript(snip.title)}','#{edit_admin_article_layout_snippet_path(snip.article_layout.id, snip.id, :format => :dialog)}');", :class => "edit")
        out << "<span class=\"title\">#{snip.title}</span>"
        out << "</div>"
      end
      out << render_cell(snip.cell_controller, snip.cell_action, :article_layout => article_layout, :article => article, :options => snip.options, :snip_id => snip.id, :current_user => current_user)
      out << "</div>"
      out << "<div class=\"cleanup\"></div>" if has_frontend_controls?
      out << "</div>" if has_frontend_controls?
    end
    out << "</div>" if has_frontend_controls?
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
