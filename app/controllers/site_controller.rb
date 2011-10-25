class SiteController < ApplicationController
  
  skip_authorization_check
  
  def show
    @cfg = cfg # get global configuration, see application controller
    @hp = yard_home
    if params[:page_url].blank? && params[:lang].blank?
      redirect_to yard_home_link, :status => 301
    elsif params[:page_url].blank? && !params[:lang].blank? && params[:lang] =~ $AVAILABLE_LANGUAGES
      lang_home = yard_home(params[:lang])
      redirect_to get_yard_url(lang_home.id), :status => 301
    elsif !params[:page_url].blank?
      splitted_page_url = params[:page_url].split('/')
      @page = Page.where(:pretty_url => splitted_page_url.last).first unless splitted_page_url.last.nil?
      acestors_and_self = (@page.ancestors.map{|a| a.title.urlify} - [params[:lang]]) << @page.title.urlify unless @page.blank?
      url_and_page_ancestors_matching = splitted_page_url == acestors_and_self
      if @page && @page.is_reserved? && (current_user.nil? || !current_user.is_privileged?)
        render_error('401')
      elsif @page && @page.published && (@page.lang == params[:lang]) # && url_and_page_ancestors_matching
        @meta_title = @page.meta_title.blank? ? "#{@cfg.site_name} #{@cfg.site_page_title}" : "#{@page.meta_title} - #{@cfg.site_name} #{@cfg.site_page_title}"
        @meta_description = @page.meta_description.blank? ? "#{@cfg.site_desc}" : "#{@page.meta_description} #{@cfg.site_desc}"
        @meta_keywords = @page.meta_keywords.blank? ? "#{@cfg.site_keywords}" : "#{@page.meta_keywords}, #{@cfg.site_keywords}"
        
        # @layout_name = Layout.find(@cfg.theme_name, @page.layout_name).path
        # render :layout => @layout_name unless @layout_name.blank?    
        render :layout => Layout.find(@cfg.theme_name, @page.layout_name).path      
      else
        render_error('404')
      end
    else
      render_error('404')
    end
  end
  
  
  
end
