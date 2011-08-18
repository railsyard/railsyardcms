module ApplicationHelper
  
  def yield_snippets(page, area)
    out = ""
    page.snippets.for_area(area).map do |snip|
      # If there is a value 'extra_class' is defined in the options, these will be assigned to the *div*
      # surrounding the snippet
      extra_class = (snip.options.is_a?(Hash) && snip.options.has_key?(:extra_class)) ? snip.options[:extra_class] : ""
      
      # The snippet has a class *snippet*. You can give a default style to all snippets by using this class.
      # The extra_class clan be set in the backend for some snippets and can be used to give a specific file to this
      # special snipit.
      out << "<div class=\"snippet #{extra_class}\" id=\"snippet-#{snip.id}\">"
      out << render_cell(snip.cell_controller, snip.cell_action, :page => page, :options => snip.options, :snip_id => snip.id)
      out << "</div>"
    end
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
