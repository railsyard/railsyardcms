class Admin::PagesController < Admin::AdminController
  
  ## manual authorization
  before_filter do |controller|
    controller.check_role("admin")
  end
  
  ## CanCan authorization - see Ability model
  authorize_resource
  
  def index
    @admin_editing_language = admin_editing_language
    @pages = Page.without_roots.where(:lang => @admin_editing_language).order("updated_at DESC")
    @root_page = Page.where(:title => @admin_editing_language, :ancestry => nil).first
  end
  
  def show
    @admin_editing_language = admin_editing_language
    @page = Page.find(params[:id])
    @snippets_available = Snippet.available
    @layouts = Layout.all(cfg.theme_name)
    @current_layout = Layout.find(cfg.theme_name, @page.layout_name)
    @snippets = @page.snippets.includes(:association).order("associations.position")
  end
  
  def new
    @admin_editing_language = admin_editing_language
    @page = Page.new
    @root_page = Page.where(:title => @admin_editing_language, :ancestry => nil).first 
    @layouts = Layout.all(cfg.theme_name)
    @current_layout = @layouts.first
  end
  
  def create
    @admin_editing_language = admin_editing_language
    @page = Page.new(params[:page])
    @page.pretty_url = @page.pretty_url.urlify.blank? ? @page.title.urlify : @page.pretty_url.urlify
    @page.lang = @admin_editing_language
    @page.meta_description = @page.title if @page.meta_description.blank?
    @page.meta_title = @page.title if @page.meta_title.blank?
    @page.publish_at = Time.now if @page.published    
    @page.position = Page.where(:lang => @admin_editing_language, :ancestry => nil).first.children.order("position ASC").last.try(:position).to_i+1
    # TO-DO selettore posizione pagina nell'albero
    if @page.parent.blank?
      lang_root_page = Page.find_by_title(@admin_editing_language)
      @page.parent = lang_root_page unless lang_root_page.blank?
    end
    if @page && @page.save && @page.errors.empty?
      redirect_to admin_pages_path()
    else
      render :action => "new"
    end
  end
  
  def edit
    @admin_editing_language = admin_editing_language
    @page = Page.find(params[:id])
    @root_page = Page.where(:title => @admin_editing_language, :ancestry => nil).first
    @layouts = Layout.all(cfg.theme_name)
    @current_layout = Layout.find(cfg.theme_name, @page.layout_name)
  end
  
  def update
    @admin_editing_language = admin_editing_language
    @page = Page.find(params[:id])
    if @page
      @page.attributes = params[:page]
      @page.pretty_url = @page.pretty_url.urlify.blank? ? @page.title.urlify : @page.pretty_url.urlify
      @page.lang = @admin_editing_language
      @page.meta_description = @page.title if @page.meta_description.blank?
      @page.meta_title = @page.title if @page.meta_title.blank?
      @page.publish_at = Time.now if @page.published
      # TO-DO selettore posizione pagina nell'albero
      if @page.parent.blank?
        lang_root_page = Page.find_by_title(@admin_editing_language)
        @page.parent = lang_root_page unless lang_root_page.blank?
      end
      if @page.save && @page.errors.empty?
        redirect_to admin_pages_path()
      else
        render :action => "edit"
      end
    end
  end
  
  def destroy
    page = Page.find(params[:id])
    if page
      if !page.children.blank? && (lang_root_page = Page.find_by_title(page.lang))
        page.children.map do |c|
          c.parent = lang_root_page
          c.save
        end
      end
      page.destroy
      redirect_to admin_pages_path()
    end
  end
  
  def sort    
    # TO-DO some checks and robust code
    error = false;
    root_page = Page.where(:title => params[:admin_editing_language], :ancestry => nil).first
    serialized_tree = params[:page]   
    serialized_tree.split('&').each_with_index do |node, i| 
      page_string = node[node.rindex('[')+1..node.rindex(']')-1]
      parent_string = node[node.rindex('=')+1..node.length]   
      page = Page.where(:id => page_string.to_i).first
      page.parent_id = (parent_string == 'root' ? root_page.id : parent_string.to_i)
      page.position = i+1
      page.save
      error = true unless page.errors.empty?
    end
   @result = error ? "Error updating pages tree." : "Pages tree updated."
   # Renders sort.js.erb
  end
  
  def toggle
    @page = Page.find(params[:id])
    @error = true unless @page && @page.toggle
    # Renders toggle.js.erb
  end
  
  def set_editing_language
    session[:admin_editing_language] = params[:admin_editing_language] unless params[:admin_editing_language].blank?
    # Renders set_editing_language.js.erb
  end
  
  def apply_layout
    @page = Page.find(params[:id])
    if Layout.find(cfg.theme_name, params[:selected_layout])
      @page.snippets.map{|s| s.update_attribute(:area, "limbo")}
      @page.update_attribute(:layout_name, params[:selected_layout])
    end
    # Renders apply_layout.js.erb
  end
  
end
