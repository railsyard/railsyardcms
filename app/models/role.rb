class Role < ActiveRecord::Base
  #attr_accessible #none
  validates :name, :presence => true, :uniqueness => true
  has_many :grades
  has_many :users, :through => :grades, :uniq => true
end
