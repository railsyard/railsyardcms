class Article < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, :through => :categorizations
  accepts_nested_attributes_for :categorizations
  
  belongs_to :user
  
  validates_presence_of :title
  validates_length_of :title, :minimum => 3
  validates_uniqueness_of :pretty_url
  # validates_presence_of :categories
  
  # paperclip
  has_attached_file :featured_image,
                    :styles => {:large => "500x500>", :medium => "300x300>", :thumb => "100x100>", :highlight => "307x132>" },
                    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
  
  scope :published, :conditions => ["published = ?", true]
  scope :drafts, :conditions => ["published = ?", false]
  scope :not_reserved, :conditions => ["reserved = ?", false]
  scope :for_public_feed, :conditions => ["reserved = ? AND published = ?", false, true], :order => "publish_at DESC"
    
  def publish
    update_attributes!(:published => true, :publish_at => Time.now)
  end
  
  def unpublish
    update_attributes!(:published => false, :publish_at => nil)
  end
  
  def toggle
    if !self.published
      self.publish
    else
      self.unpublish
    end
  end
  
end
