plugin_path = File.dirname __FILE__

# Loading localization files
I18n.load_path += Dir[File.join(plugin_path, 'config', 'locales', '*.{rb,yml}')]

# Loading Helper
ActionView::Base.class_eval 'include ActsAsCategoryHelper'

# Loading acts_as_*
ActiveRecord::Base.class_eval 'include ActiveRecord::Acts::Category'
ActiveRecord::Base.class_eval 'include ActiveRecord::Acts::CategoryContent'
