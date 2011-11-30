class Upload < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  
  # Paperclip
  has_attached_file :data,  :styles => { :thumb => "80x80>", :small => "150x150>", :medium => "300x300>", :large => "650x650>" },
                            :url  => "/uploads/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/uploads/:id/:style/:basename.:extension"
  
  # if attachment is not an image prevents the resize post processor from running
  before_post_process :is_image? 
  
  # Paperclip Validations
  validates_attachment_presence :data

  # Used by before_post_process validation to skip images post processing if not an image
  def is_image?
    ["image/jpeg", "image/pjpeg", "image/png", "image/x-png", "image/gif", "image/bmp"].include?(self.data_content_type) 
  end
  
  def to_jq_upload
    {
      "name" => read_attribute(:data_file_name),
      "size" => data_file_size,
      "url" => data.url,
      "thumbnail_url" => data.url(:thumb),
      "delete_url" => "/admin/uploads/#{id}",
      "delete_type" => "DELETE" 
     }
  end
end
