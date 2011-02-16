class Template < ActiveRecord::Base
  
  has_many :associations, :dependent => :destroy
  has_many :snippets, :through => :associations, :dependent => :destroy
  
  validates_presence_of :name
  validates_length_of :name, :minimum => 3
  validates_uniqueness_of :name
  
  private
  
  def self.clone_template(orig_name, cloned_name)
    orig = Template.find_by_name(orig_name.to_s)
    if orig
      cloned = orig.clone
      cloned.name = cloned_name.to_s
      cloned.save
      orig.snippets.each do |origsn|
        clonedsn = origsn.clone
        clonedsn.template = cloned
        clonedsn.save
        clonedsn.association.update_attribute(:location, origsn.association.location)
      end  
    else
      puts "Original template not found!"
    end
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)