module ApplicationHelper
  
  def yield_snippets(page, area)
    out = ""
    page.snippets.for_area(area).map do |snip|
      out << render_cell(snip.cell_controller, snip.cell_action, :page => page, :options => snip.options)
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
