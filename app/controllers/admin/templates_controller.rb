class Admin::TemplatesController < Admin::AdminController
  
  before_filter do |controller|
    controller.check_role("Admin")
  end
  
  def index
    @templates = Template.all
  end
  
  def new
    # NOTICE: @template is something like a reserved Rails variable name! Throws an error, never seen it before, watch out.
    @templ = Template.new
    render :update do |page|
      page.replace_html("new-template", :partial => "/admin/templates/new_quick", :object => @templ)
      page.visual_effect(:blind_down, "new-template", :duration => 1)
    end
  end
  
  def create
    @templ = Template.new(params[:template])
    if @templ && @templ.save && @templ.errors.empty?
      render :update do |page|
        page.replace_html("templates-sidebar", :partial => "/admin/templates/sidebar", :object => Template.all)
        page.visual_effect(:highlight, "template-#{@templ.id}", :duration => 1, :startcolor => '#fdddb7', :endcolor => '#EFEFEF')
      end
    else
      logger.error "Error in Template creation"
      render :nothing => true
    end
  end
  
  def show
    @templates = Template.all
    @templ = Template.find(params[:id])
  end
  
  def destroy
    @templ = Template.find(params[:id])
    @templ.destroy
    render :update do |page|
      page.visual_effect :fade, "template-#{@templ.id}"
    end
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)