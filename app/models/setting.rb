class Setting < ActiveRecord::Base
  attr_accessible :site_page_title,
                  :default_page_keywords,
                  :default_page_desc,
                  :default_lang,
                  :analytics,
                  :theme_name,
                  :frontend_controls,
                  :archive_url
end
