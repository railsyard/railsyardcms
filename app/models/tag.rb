class Tag < ActiveRecord::Base
  has_many :categorizations
  has_many :articles, :through => :categorizations
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)