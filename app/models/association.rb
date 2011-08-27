class Association < ActiveRecord::Base
  #attr_accessible #none
  #validates :page_id, :presence => true
  validates :snippet_id, :presence => true
  belongs_to :page
  belongs_to :snippet
  belongs_to :article_layout
end
