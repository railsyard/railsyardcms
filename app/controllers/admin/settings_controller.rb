class Admin::SettingsController < Admin::AdminController
  
  ## manual authorization
  before_filter do |controller|
    controller.check_role("admin")
  end
  
  ## CanCan authorization - see Ability model
  authorize_resource
  
  def edit
    @setting = cfg
    @admin_editing_language = admin_editing_language
  end
  
  def update
    @setting = cfg
    current_theme = cfg.theme_name
    if @setting
      @setting.attributes = params[:setting]
      if @setting.save && @setting.errors.empty?
        change_theme(params[:setting][:theme_name]) unless params[:setting][:theme_name].eql? current_theme
        flash[:notice] = "<p>#{t 'admin.settings.configuration_saved'}</p>".hs
        redirect_to edit_admin_settings_path()
      else
        render :action => "edit"
      end
    end
  end
  
  private
  
  def change_theme(theme)
    first_layout = Layout.all(theme).first.filename
    Page.all.map do |p|
      p.snippets.map{|s| s.update_attribute(:area, "limbo")}
      p.update_attribute(:layout_name, first_layout)
    end
    ArticleLayout.all.map do |l|
      l.snippets.map{|s| s.update_attribute(:area, "limbo")}
      l.update_attribute(:layout_name, first_layout)
    end
  end

end
