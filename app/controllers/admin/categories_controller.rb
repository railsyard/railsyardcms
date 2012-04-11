class Admin::CategoriesController < Admin::AdminController
  
  ## manual authorization
  before_filter do |controller|
    controller.check_roles(["admin", "article_writer"])
  end
  
  ## CanCan authorization - see Ability model
  authorize_resource
  
  def index
    @admin_editing_language = admin_editing_language
    @categories = Category.all
  end
  
  def new
    @category = Category.new
    respond_to do |format|
      format.js #renders new.js.erb
    end
  end
  
  def create
    @category = Category.new(params[:category])
    @category.pretty_url = @category.pretty_url.urlify.blank? ? @category.name.urlify : @category.pretty_url.urlify
    if @category && @category.save && @category.errors.empty?
      redirect_to admin_categories_path
    else
      # TO-DO alert msg if creation ok or bad
    end
  end
  
  def edit
    @category = Category.find(params[:id])
    respond_to do |format|
      format.js #renders edit.js.erb
    end
  end
  
  def update
    @category = Category.find(params[:id])
    @category.attributes = params[:category]
    @category.pretty_url = @category.pretty_url.urlify.blank? ? @category.name.urlify : @category.pretty_url.urlify
    if @category && @category.save && @category.errors.empty?
      redirect_to admin_categories_path
    else
      # TO-DO alert msg if update ok or bad
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    if @category && @category.destroy
      redirect_to admin_categories_path
    else
      # TO-DO alert msg if deletion ok or bad
    end
  end
    
  def quick_create
    @category = Category.new(params[:category])
    @category.pretty_url = @category.pretty_url.urlify.blank? ? @category.name.urlify : @category.pretty_url.urlify
    if @category && @category.save && @category.errors.empty?
      respond_to do |format|
        format.js #renders quick_create.js.erb
      end
    else
      respond_to do |format|
        format.js {
          render :js => "alert('Something went wrong!');"
        }
      end
    end
  end
  
end
