class Admin::SnippetsController < Admin::AdminController
  
  ## manual authorization
  before_filter do |controller|
    controller.check_role("admin")
  end
  
  ## CanCan authorization - see Ability model
  authorize_resource
  
  def edit
    @snippet = Snippet.find(params[:id])  
    
    if @snippet.serialized_attributes.any? {|att| att[1].eql? "article_categories"}
      @categories = Category.all
    end
    
    respond_to do |format|
      format.html { render }
      format.dialog { render :layout => false }
    end
  end
  
  def update
    @snippet = Snippet.find(params[:id])
    if @snippet
      back_url = @snippet.article_layout ? edit_admin_article_layout_path(@snippet.article_layout.lang) : admin_page_path(@snippet.page.id)
      @snippet.attributes = params[:snippet]
      respond_to do |format|
        if @snippet.save && @snippet.errors.empty?
          format.html { redirect_to back_url }
          format.dialog { render :text => "success", :status => 400 }
        else
          format.html { render :action => "edit" }
          format.dialog { render :text => "#{@snippet.errors.full_messages.each { |m| "<li>#{m}</li>"}.join('') }", :layout => false }
        end
      end
    end
  end
  
  ## Creation, sorting and moving between areas
  # TO-DO more efficient code. I'm rushing.
  def sort
    if params[:article_layout_id]
      @resource_snippets = ArticleLayout.find(params[:article_layout_id]).snippets
    elsif params[:page_id]
      @resource_snippets = Page.find(params[:page_id]).snippets
    end
    
    params[:areas].map do |area|
      unless area[1].blank?
        area_name = area[0]
        received_snippets = area[1].split(',')
        received_snippets.each_with_index do |rec_snip, position|
          # New snippet creation
          unless @resource_snippets.map{|snip| snip.handler}.include?(rec_snip) # checks if the snippet was already present on page
            rec_snip_class, rec_snip_action = rec_snip.split('%')[0], rec_snip.split('%')[1]
            available_snippet = Snippet.find_available(rec_snip_class, rec_snip_action) # search the received snippet in the available snippets
            @new_snippet = @resource_snippets.create :area => area_name,                    # and creates the real snippet for the area on db
                                                 :handler => rec_snip,
                                                 :title => available_snippet["name"],
                                                 :cell_action => available_snippet["method"],
                                                 :cell_controller => rec_snip_class
          end
          # Snippets sorting and area change
          current_snippet = @resource_snippets.find_by_handler(rec_snip)
          current_snippet.association.update_attribute(:position, position+1)
          current_snippet.update_attribute(:area, area_name)
        end
      end
    end
    # Renders sort.js.erb
  end
  
  def purge
    #TO-DO empty trash bin (limbo)
  end
  
  def destroy
    @snippet = Snippet.find(params[:id])
    if @snippet
      respond_to do |format|
        if @snippet.destroy && @snippet.errors.empty?
          format.html { redirect_to admin_page_url(@snippet.page.id) }
          format.json { render :json => {} }
        else
          format.html { render :action => 'edit' }
          format.json { render :json => @snippet.errors.merge({ :message => 'There was an error!' }), :status => :unprocessable_entity }
        end
      end
    end
  end
  
end


