class Setting < ActiveRecord::Base
  attr_accessible :site_name, :site_page_title, :site_keywords, :site_desc, :default_lang, :site_base_url, :analytics, :theme_name
  
end
