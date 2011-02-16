class Setting < ActiveRecord::Base
 belongs_to :homepage, :class_name => 'Page', :foreign_key => 'homepage_id'
 
 validates_presence_of :site_name
 validates_length_of :site_name, :minimum => 3
 
 validates_presence_of :site_base_url
 
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)