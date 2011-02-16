class Admin::AssetsController < Admin::AdminController

  def create 
    filename = params[:Filedata].original_filename  
    if filename.match(/\.(jpg|png|bmp|gif)$/i)
      @asset = Image.new(:swfupload_file => params[:Filedata])
    elsif filename.match(/\.(txt|doc|docx|xls|xlsx|ppt|pptx|pps|ppsx|pdf|odt|ods|odf|odp|xml|csv|htm|html)$/i)
      @asset = Document.new(:swfupload_file => params[:Filedata])
    elsif filename.match(/\.(zip|rar|tar|tar.gz|tar.bz2|gz|bz2)$/i)
      @asset = Archive.new(:swfupload_file => params[:Filedata])
    elsif filename.match(/\.(avi|mpeg|mpg|mkv|mov|wmv|3gp|flv)$/i)
      @asset = Video.new(:swfupload_file => params[:Filedata])
    elsif filename.match(/\.(wav|mp3|wma)$/i)
      @asset = Audio.new(:swfupload_file => params[:Filedata])
    else
      @asset = Asset.new(:swfupload_file => params[:Filedata])
    end
      
    if !params[:asset].blank? && !params[:asset][:attachable_type].blank? && !params[:asset][:attachable_id].blank?
      attachable = params[:asset][:attachable_type].classify.constantize.find(params[:asset][:attachable_id])
      @asset.attachable = attachable if attachable
    end
      
    if @asset.save   
      render :partial => "upload", :object => @asset #check function AddImage(src) in swfupload_handlers.js
    else
      render :text => "error"
    end 
  end
  
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    render :update do |page|
       page.visual_effect :fade, "asset_#{@asset.id}"
     end
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)