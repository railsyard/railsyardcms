class Snippet < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  attr_accessible :title, :description, :published, :publish_at, :div_id, :div_class, :div_style, :area, :cell_controller, :cell_action, :handler, :options
  has_one :association, :dependent => :destroy
  has_one :page, :through => :association
  has_one :article_layout, :through => :association
  has_many :snippet_components
  accepts_nested_attributes_for :snippet_components
  
  validates_presence_of :title, :presence => true, :length => {:minimum => 3}
  
  serialize :options, Hash
  
  scope :published, :conditions => ["published = ?", true]
  scope :drafts, :conditions => ["published = ?", false]
  scope :for_area, lambda {|area| where("area = ?", area).order('associations.position ASC')}
  
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
  
  def self.available
    cells = []
    search_cells.map do |cell_conf_file|
      cells << YAML.load_file(cell_conf_file)
    end
    cells.map{|c| c["cell"]}
  end
  
  def self.search_cells
    #cells_path = "#{Rails.root.to_s}/app/cells"
    files = Cell::Rails.view_paths.map { |p| p.to_s + '/*.yml' }
    Dir.glob(files).select do |file|
      File.readable?("#{file}")
    end.compact.uniq
  end
  
  def self.find_available(snip_controller, snip_action)
    found_snippet_controller = available.select{|av_snip_class| av_snip_class["class"].eql?(snip_controller)}
    found_snippet_action = found_snippet_controller[0]["actions"].select{|av_snip_action| av_snip_action["method"].eql?(snip_action)}
    found_snippet_action[0]
  end
  
  def serialized_attributes
    Snippet.find_available(self.cell_controller, self.cell_action)["serialized_attributes"]
  end
  
end
