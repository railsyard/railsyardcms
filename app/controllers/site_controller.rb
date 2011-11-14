class SiteController < ApplicationController
  
  skip_authorization_check
  
  def show
    @cfg = cfg # get global configuration, see application controller
    @hp = yard_home
    if params[:page_url].blank? && params[:lang].blank?
      redirect_to yard_home_link, :status => 301
    elsif params[:page_url].blank? && !params[:lang].blank? && check_language_enabled(params[:lang])
      lang_home = yard_home(params[:lang])
      redirect_to get_yard_url(lang_home.id), :status => 301
    elsif !params[:page_url].blank?
      splitted_page_url = params[:page_url].split('/')
      @page = Page.where(:pretty_url => splitted_page_url.last).first
      if @page && @page.is_reserved? && (current_user.nil? || !current_user.is_privileged?)
        render_error('401')
      elsif @page && @page.published && check_path(@page, splitted_page_url) && check_language_enabled(@page.lang)
        @meta_title = "#{@page.meta_title} - #{@cfg.site_page_title}".truncate(70, :omission => '')
        @meta_description = "#{@page.meta_description}".truncate(140, :omission => '')
        @meta_keywords = "#{@page.meta_keywords}"
        render :layout => Layout.find(@cfg.theme_name, @page.layout_name).path      
      else
        render_error('404')
      end
    else
      render_error('404')
    end
  end
  
  private
  
  def check_path(page, splitted_url)
    acestors_and_self = (page.ancestors.map{|a| a.pretty_url} - [params[:lang]]) << page.pretty_url
    url_and_page_ancestors_matching = splitted_url == acestors_and_self
  end
  
  def check_language_enabled(lang)
    language_enabled = lang =~ $AVAILABLE_LANGUAGES
  end
  
end
