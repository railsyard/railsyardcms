class Admin::SettingsController < Admin::AdminController
  
  before_filter do |controller|
    controller.check_role("Admin")
  end
  
  def edit
    @setting = cfg
  end
  
  def update
    @setting = cfg
    current_theme = cfg.theme_name
    if @setting
      @setting.attributes = params[:setting]
      if @setting.save && @setting.errors.empty?
        change_theme unless params[:setting][:theme_name].eql? current_theme
        flash[:notice] = "<p>#{t 'admin.settings.configuration_saved'}</p>".hs
        redirect_to edit_admin_settings_path()
      else
        render :action => "edit"
      end
    end
  end
  
  private
  
  def change_theme
    Page.all.map do |p|
      p.layout_name = "default"
      p.save
    end
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)