class Admin::UploadsController < ApplicationController
  
  def index
    @uploads = Upload.where(:attachable_type => params["attachable_type"], :attachable_id => params["attachable_id"])
    render :json => @uploads.collect { |p| p.to_jq_upload }.to_json
  end
  
  def create
    ct = params[:upload][:data].content_type
    @upload = content_type_lookup(ct).classify.constantize.new(params[:upload])
    if @upload.save && @upload.errors.empty?
      render :json => [@upload.to_jq_upload].to_json
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end
  
  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    render :json => true
  end
    
  # used only for loading the upload panel via ajax
  def new
    @attachable = params["attachable_type"].classify.constantize.find(params["attachable_id"])
    render :layout => false
  end
  
  # used for editing the alt/description in a lightbox form
  def edit
    @upload = Upload.find(params[:id])
  end
  
  def update
    @upload = Upload.find(params[:id])
    unless @upload.blank?
      @upload.attributes = params[:upload]
      if @upload.save && @upload.errors.empty?
        render :js => "$('div[role=\"dialog\"]').hide();"
      else
        render :js => "alert('Something went wrong!');"
      end
    end
  end
  
  private
  
  def content_type_lookup(ct)
    case
    when ct =~ /^image\/\w*\z/
      "Image"
    when ct =~ /^audio\/\w*\z/
      "Audio"
    when ct =~ /^video\/\w*\z/
      "Video"
    when ct =~ /^application\/(zip|rar|x-rar-compressed|gzip|x-gzip|bzip2|x-bzip2)\z/
      "Archive"
    else
      "Document"
    end
  end
  
end
