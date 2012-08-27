class Admin::TagsController < Admin::AdminController

  ## CanCan authorization - see Ability model
  authorize_resource

  def index
    t = Tag.arel_table
    @tags = Tag.where(t[:name].matches "%#{params[:q]}%").order("name ASC")

    respond_to do |wants|
      wants.js { render :json => @tags.collect { |t| t.name } }
    end
  end

end
