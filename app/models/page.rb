class Page < ActiveRecord::Base 
  attr_accessible :title, :pretty_url, :published, :publish_at, :visible_in_menu, :meta_title, :meta_description, :meta_keywords, :script, :div_id, :div_class, :div_style, :reserved, :layout_name, :lang, :position, :featured_image
  has_ancestry
  default_scope :order => "position ASC"
  
  #acts_as_list :scope => :ancestry
  # acts_as_list
  # # Scope conditions for acts_as_list
  # # Scopes both for parent_id and position
  # def scope_condition
  #   "#{connection.quote_column_name("ancestry")} = #{quote_value(ancestry)} AND #{connection.quote_column_name("lang")} = #{quote_value(lang)}" 
  #   # Equals to:  "\'ancestry\' = \'#{ancestry}\' AND \'lang\' = \'#{lang}\'" 
  # end
  
  has_many :associations, :dependent => :destroy
  has_many :snippets, :through => :associations, :dependent => :destroy
  
  validates_presence_of   :title
  validates_length_of     :title, :minimum => 2
  validates_presence_of   :pretty_url
  validates_uniqueness_of :pretty_url
  validates_presence_of   :lang
  
  before_create :set_order
  
  # paperclip
  has_attached_file :featured_image,
                    :styles => {:large => "500x500>", :medium => "300x300>", :thumb => "100x100>", :banner => "960x303>" },
                    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
  
  scope :published, :conditions => ["published = ?", true]
  scope :drafts, :conditions => ["published = ?", false]
  scope :for_language, lambda {|lang| {:conditions => ["lang = ?", lang]} }
  scope :not_reserved, :conditions => ["reserved = ?", false]
  scope :without_roots, :conditions => ["ancestry != ?", 'NULL']
  
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
  
  def is_reserved?
    self.reserved == true
  end
  
  private
  
  def set_order
    self.position ||= self.siblings.order("position ASC").last.try(:position).to_i+1
  end
  
  
end
