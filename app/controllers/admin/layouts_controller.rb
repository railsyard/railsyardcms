class Admin::LayoutsController < ApplicationController
  
  before_filter do |controller|
    controller.check_role("Admin")
  end
  
  def update
    @lay = Layout.find(params[:id])
    @templ = Template.find(params[:template])
    if @lay && @templ
      @lay.template = @templ
      if @lay.save
        render :update do |page|
          page.replace_html("ajax-notice", "<p>#{t 'admin.layouts.layout_saved'}</p>".hs)
          page.visual_effect("blindDown", "ajax-notice")
          page << "setTimeout ( \"$(\'ajax-notice\').blindUp();\", 4000 );"
        end
      else
        render :update do |page|
          page.replace_html("ajax-notice", "<p>#{t 'admin.layouts.error_saving_layout'}</p>".hs)
          page.visual_effect("blindDown", "ajax-notice")
        end
      end
    else
      logger.error "Can't update layout"
    end
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)