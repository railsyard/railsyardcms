class Page < ActiveRecord::Base
  acts_as_category
  
  # will paginate
  cattr_reader :per_page
  @@per_page = 20
  
  has_many :associations, :dependent => :destroy
  has_many :snippets, :through => :associations, :dependent => :destroy
  
  belongs_to :user
  
  validates_presence_of   :name
  validates_length_of     :name, :minimum => 3
  validates_presence_of   :pretty_url
  validates_uniqueness_of :pretty_url
  validates_presence_of   :lang
  validates_presence_of   :user_id
  
  default_scope :conditions => {:deleted => false}
  
  named_scope :published, :conditions => ["published = ?", true]
  named_scope :drafts, :conditions => ["published = ?", false]
  named_scope :for_language, lambda {|lang| {:conditions => ["lang = ?", lang]} }
  named_scope :not_reserved, :conditions => ["reserved = ?", false]
  
  def publish
    update_attributes!(:published => true, :publish_at => Time.now)
  end
  
  def unpublish
    update_attributes!(:published => false)
  end
  
  def toggle
    if !self.published
      self.publish
    else
      self.unpublish
    end
  end
  
  def is_reserved?
    self.reserved == true
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)