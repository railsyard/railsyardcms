class Admin::PagesController < Admin::AdminController

  before_filter do |controller|
    controller.check_role("Admin")
  end
  
  def index
    @admin_editing_language = admin_editing_language
    @pages = Page.paginate  :all,
                            :conditions => ["lang = ?", @admin_editing_language],
                            :order => "updated_at DESC",
                            :page => params[:pagination]
  end
  
  def show
    @admin_editing_language = admin_editing_language
    @page = Page.find(params[:id])
    @templates = Template.all
  end

  def new
    @admin_editing_language = admin_editing_language
    @page = current_user.pages.new
  end
  
  def create
    @admin_editing_language = admin_editing_language
    @page = current_user.pages.new(params[:page])
    @page.pretty_url = @page.pretty_url.urlify.blank? ? @page.name.urlify : @page.pretty_url.urlify
    @page.lang = @admin_editing_language
    @page.meta_desc = @page.name if @page.meta_desc.blank?
    @page.meta_title = @page.name if @page.meta_title.blank?
    @page.publish_at = Time.now if @page.published
    if @page && @page.save && @page.errors.empty?
      redirect_to admin_pages_path()
    else
      render :action => "new"
    end
  end

  def edit
    @admin_editing_language = admin_editing_language
    @page = Page.find(params[:id])
  end
  
  def update
    @admin_editing_language = admin_editing_language
    @page = Page.find(params[:id])
    if @page
      @page.attributes = params[:page]
      @page.pretty_url = @page.pretty_url.urlify.blank? ? @page.name.urlify : @page.pretty_url.urlify
      @page.lang = @admin_editing_language
      @page.meta_desc = @page.name if @page.meta_desc.blank?
      @page.meta_title = @page.name if @page.meta_title.blank?
      @page.publish_at = Time.now if @page.published
      if @page.save && @page.errors.empty?
        redirect_to admin_pages_path()
      else
        render :action => "edit"
      end
    end
  end
  
  # Warning: this is a cascade delete, it deletes all children pages
  def destroy
    page = Page.find(params[:id])
    page.descendants.map {|d| d.destroy}
    page = Page.find(params[:id]) # I need to reload the page from db for a bug of acts_as_category gem, as on deleting the parent it tries to update the children already deleted
    page.destroy   
    redirect_to admin_pages_path()
  end
  
  def update_positions
    #acts_as_category original way of sorting:
    #Page.update_positions(params)
    
    #My HACK: due to multi-language the original method no longer works
    params.each_key do |key|
      if key.include?('aac_sortable_tree_')
        params[key].each_with_index do |id, pos|
          Page.find(id).update_attribute(:position, pos+1) #positions starts form 1, not from 0, for being compliant with original acts_as_category
        end
      end
    end
    render :nothing => true
  end
  
  def toggle
    pg = Page.find(params[:id])
    if pg
      pg.toggle
      render :update do |page|
        page.replace "page-#{pg.id}", :partial => 'admin/pages/item', :object => pg
      end
    else
      logger.error "Admin page toggle error"
    end
  end
  
  def editing_language
    session[:admin_editing_language] = params[:admin_editing_language] unless params[:admin_editing_language].blank?
    render :update do |page|
      if params[:redirect_to_index] == 'true'
      	page.redirect_to :action => :index
  	  else
        page << "window.location.reload()"
      end
    end
  end
  
  def apply_template
    @page = Page.find(params[:id])
    @templ = Template.find(params[:template_id])
    if @page && @templ
      @page.snippets.each {|s| s.destroy}
      @templ.snippets.each do |templ_snippet|
        cloned_snippet = templ_snippet.clone
        cloned_snippet.page = @page
        cloned_snippet.save
        cloned_snippet.association.update_attribute(:location, templ_snippet.association.location)
      end
    else
      logger.error "Problem applying page template"
    end
    redirect_to admin_page_path(@page)
  end
  
  private
  
  def admin_editing_language
    session[:admin_editing_language].blank? ? 'en' : session[:admin_editing_language]
  end

end
# Author::    Silvio Relli  (mailto:silvio@relli.org)