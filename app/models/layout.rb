class Layout
  include SimpleModel
  attributes :title, :view, :areas
  validates :title, :presence => true
  validates :view, :presence => true
end
