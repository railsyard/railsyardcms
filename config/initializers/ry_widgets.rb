RAILSYARD_WIDGET_PATHS ||= []
RAILSYARD_WIDGET_PATHS << "#{Rails.root.to_s}/app/cells"
# Setting the view_paths to the collected paths from the application and the gems
Cell::Rails.view_paths = RAILSYARD_WIDGET_PATHS