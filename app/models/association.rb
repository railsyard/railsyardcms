class Association < ActiveRecord::Base
  
  #acts_as_list :scope => 'page_id = #{page_id} and position = #{position} and location #{location}'
  # to-do
  # http://macdiggs.com/2007/08/27/customizing-scope-in-acts_as_list/
  # http://zilkey.com/2008/3/24/advanced-acts_as_list-scope-with-multiple-columns
  
  # acts_as_list disabled because it does not work on join table (with has_many_through)
  # I have to order and scope on location and position attributes manually
  # see the Snippet model
  # acts_as_list :scope => :page
  
  belongs_to :page
  belongs_to :snippet
  belongs_to :template
  
  default_scope :order => 'position ASC'
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)