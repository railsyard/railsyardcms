class Admin::SnippetsController < Admin::AdminController
  
  before_filter do |controller|
    controller.check_role("Admin")
  end
  
  def index
    @snippets = Snippet.all
  end
  
  def show
    @snippet = Snippet.find(params[:id])
  end

  def new
    @categories = Category.all
    @snippet = Snippet.new
  end
  
  def create
    @categories = Category.all
    if (params[:page_id] || params[:template_id]) && params[:snippet] && params[:snippet][:kind] && params[:location]
      
      is_template = !params[:template_id].blank?
      page = Page.find(params[:page_id]) if !is_template
      templ = Template.find(params[:template_id]) if is_template
      
      if page || templ
        #@snippet = params[:snippet][:type].classify.constantize.new(params[:snippet]) #nice method but if there's some errors during creation the object gets the snippet subclass (due to STI) and the form no longer works.
        @snippet = Snippet.new(params[:snippet])
        @snippet.page = page if (page && !is_template)
        @snippet.template = templ if (templ && is_template)
        @snippet.name = params[:snippet][:kind] if @snippet.name.blank?
        
        # setting categories for articles_snippet
        unless params[:categories].blank?
          params[:categories].map do |cat|
            @snippet.categories << @categories.select {|c| c.id == cat.to_i}
          end
        end
        
        if @snippet.save && @snippet.errors.empty?
          @snippet.update_attribute(:type, params[:snippet][:kind]) #needed, otherwise type will not change as type is a reserved attribute for STI.
          @snippet.association.update_attribute(:location, params[:location])
          if params[:commit_type] == 'save' && is_template
            redirect_to edit_admin_settings_template_snippet_path(templ, @snippet) #render :action => "edit" #not working because of STI
          elsif params[:commit_type] == 'save' && !is_template
            redirect_to edit_admin_page_snippet_path(page, @snippet)
          elsif params[:commit_type] == 'save_and_close' && is_template
            redirect_to admin_settings_template_path(templ)
          elsif params[:commit_type] == 'save_and_close' && !is_template
            redirect_to admin_page_path(page)
          end
        else
          render :action => "new"
        end
      end
    end
  end

  def edit
    @categories = Category.all
    @snippet = Snippet.find(params[:id])
  end
  
  def update
    #raise params.inspect
    
    @categories = Category.all   
    if (params[:page_id] || params[:template_id]) && params[:snippet] && params[:snippet][:kind] && params[:location]
      
      is_template = !params[:template_id].blank?
      page = Page.find(params[:page_id]) if !is_template
      templ = Template.find(params[:template_id]) if is_template
      
      if page || templ
        @snippet = Snippet.find(params[:id])
        if @snippet
          @snippet.attributes = params[:snippet]
          @snippet.name = params[:snippet][:kind] if @snippet.name.blank?
      
          unless params[:categories].blank?
            @snippet.categorizations.each {|categorization| categorization.destroy}
            params[:categories].map do |cat|
              @snippet.categories << @categories.select {|c| c.id == cat.to_i}
            end
          end
      
          if @snippet.save && @snippet.errors.empty?
            @snippet.update_attribute(:type, params[:snippet][:kind])
            @snippet.association.update_attribute(:location, params[:location])
            if params[:commit_type] == 'save' && is_template
              redirect_to edit_admin_settings_template_snippet_path(templ, @snippet)
            elsif params[:commit_type] == 'save' && !is_template
              redirect_to edit_admin_page_snippet_path(page, @snippet)
            elsif params[:commit_type] == 'save_and_close' && is_template
              redirect_to admin_settings_template_path(templ)
            elsif params[:commit_type] == 'save_and_close' && !is_template
              redirect_to admin_page_path(page)
            end
          else
            render :action => "edit"
          end
        end
      end
    end
  end
  
  def destroy
    @snippet = Snippet.find(params[:id])
    back_url = ""
    if page = @snippet.association.page
      back_url = admin_page_path(page)
    elsif templ = @snippet.association.template
      back_url = admin_settings_template_path(templ)
    end  
    @snippet.destroy
    redirect_to back_url
  end
  
  def sort # ugly... TO-DO make it work in a more elegant way, I'm rushing as everyday..
    if !params[:page_id].blank?
      @stand = Page.find(params[:page_id])
    elsif !params[:template_id].blank?
      @stand = Template.find(params[:template_id])
    end
    
    if params[:snippets_list_header]
      params[:snippets_list_header].each_with_index do |id, position|
        item = @stand.associations.find(:first, :conditions => ["snippet_id = ? AND location = ?", id, 'header'])
        item.position = position
        item.save 
      end
    elsif params[:snippets_list_left]
      params[:snippets_list_left].each_with_index do |id, position|
        item = @stand.associations.find(:first, :conditions => ["snippet_id = ? AND location = ?", id, 'left'])
        item.position = position
        item.save 
      end
    elsif params[:snippets_list_center]
      params[:snippets_list_center].each_with_index do |id, position|
        item = @stand.associations.find(:first, :conditions => ["snippet_id = ? AND location = ?", id, 'center'])
        item.position = position
        item.save 
      end
    elsif params[:snippets_list_right]
      params[:snippets_list_right].each_with_index do |id, position|
        item = @stand.associations.find(:first, :conditions => ["snippet_id = ? AND location = ?", id, 'right'])
        item.position = position
        item.save 
      end
    elsif params[:snippets_list_footer]
      params[:snippets_list_footer].each_with_index do |id, position|
        item = @stand.associations.find(:first, :conditions => ["snippet_id = ? AND location = ?", id, 'footer'])
        item.position = position
        item.save 
      end
    elsif params[:snippets_list_extra]
      params[:snippets_list_extra].each_with_index do |id, position|
        item = @stand.associations.find(:first, :conditions => ["snippet_id = ? AND location = ?", id, 'extra'])
        item.position = position
        item.save 
      end
    end
    render :nothing => true
  end
  
  def toggle
    snip = Snippet.find(params[:id])
    if snip
      snip.toggle
      render :update do |page|
        page.replace "snippet-#{snip.id}", :partial => 'admin/snippets/item', :object => snip
      end
    else
      logger.error "Admin snippet toggle error"
    end
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)