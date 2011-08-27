class Admin::CategoriesController < Admin::AdminController
  
  ## manual authorization
  before_filter do |controller|
    controller.check_roles(["admin", "article_writer"])
  end
  
  ## CanCan authorization - see Ability model
  authorize_resource
  
  def create
    @category = Category.new(params[:category])
    if @category && @category.save && @category.errors.empty?
      respond_to do |format|
        format.html {
          # to be implemented with category management panel
        }
        format.js #renders create.js.erb
      end
    else
      respond_to do |format|
        format.html {
          # to be implemented with category management panel
        }
        format.js {
          render :js => "alert('Something went wrong!');"
        }
      end
    end
  end
  
end