# Fix for the annoying problem caused by the upload facility in Flash. It basically means that all the files you upload via SWFUpload have the content type of application/octet-stream, which in most cases isn’t what you want.
require 'mime/types'

class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  
  # Paperclip
  has_attached_file :source,  :styles => { :thumb => "80x80>", :small => "150x150>", :medium => "300x300>", :large => "650x650>" },
                              :url  => "/assets/uploads/:id/:style/:basename.:extension",
                              :path => ":rails_root/public/assets/uploads/:id/:style/:basename.:extension"
  
  # if attachment is not an image prevents the resize post processor from running
  before_post_process :is_image? 
  
    
  # Paperclip Validations
  validates_attachment_presence :source
  validates_attachment_size :source, :less_than => 10.megabytes
  
  # File types specified inside controller instead of here, needed for STI
  # validates_attachment_content_type :source, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp',
  #                                                             'video/avi', 'video/mpeg', 'video/quicktime',
  #                                                             'application/msword', 'application/excel', 'text/plain',
  #                                                             'application/zip', 'application/x-rar-compressed'] #add your mime types here
  
  # Used by before_post_process validation to skip images post processing if not an image
  def is_image?
    !(source_content_type =~ /^image.*/).nil?
  end
  
  # *** NOTE: I'm disabling this because is useful to know if the attachment is an image or something else. ***
  # Needed for STI + Polymorphic association, ensures that you store the base model for the STI models in the type column, otherwise :dependent => :destroy will not work
  # def attachable_type=(sType)
  #   super(sType.to_s.classify.constantize.base_class.to_s)
  # end
  
  # Fix the mime types.
  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.source = data
  end
  
end

# Author::    Silvio Relli  (mailto:silvio@relli.org)