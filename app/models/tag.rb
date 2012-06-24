class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles

  validates :name, :uniqueness => true, :presence => true, :length => {:minimum => 3}
end
