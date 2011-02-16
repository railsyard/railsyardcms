class Admin::CategoriesController < Admin::AdminController
  
  def new
    @category = Category.new
    render :update do |page|
      page.replace_html("new-category", :partial => "/admin/categories/new_quick", :object => @category)
      page.visual_effect(:blind_down, "new-category", :duration => 1)
    end
  end
  
  def create
    @category = Category.new(params[:category])
    if @category && @category.save && @category.errors.empty?
      render :update do |page|
        page.replace_html("categories-sidebar", :partial => "/admin/categories/sidebar", :object => Category.all)
        page.visual_effect(:highlight, "category-#{@category.id}", :duration => 1, :startcolor => '#fdddb7', :endcolor => '#EFEFEF')
      end
    else
      logger.error "Error in Category creation"
      render :nothing => true
    end
  end
  
  def destroy
    if params[:id].to_i != 1 #Don't delete general category
      @category = Category.find(params[:id])
      @category.destroy
      render :update do |page|
        page.visual_effect :fade, "category-#{@category.id}"
      end
    else
      logger.error "Error in Category destroy"
      render :nothing => true
    end
  end
  
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)