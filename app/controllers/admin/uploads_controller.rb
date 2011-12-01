class Admin::UploadsController < ApplicationController
  
  def index
    @uploads = Upload.where(:attachable_type => params["attachable_type"], :attachable_id => params["attachable_id"])
    render :json => @uploads.collect { |p| p.to_jq_upload }.to_json
  end
  
  def create
    @upload = Upload.new(params[:upload])
    if @upload.save
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
    
  # used only for loading the form via ajax
  def new
    @attachable = params["attachable_type"].classify.constantize.find(params["attachable_id"])
    render :layout => false
  end
  
end
