class SiteController < ApplicationController
  
  skip_authorization_check
  
  def show   
    case
    when params[:page_url].blank? && params[:lang].blank? 
      # When no language and no page are present in url (i.e. root page / )
      # Redirect to home page, language chosen according to user agent or default setting
      redirect_to get_yard_url(yard_home.id), :status => 301 
    when params[:page_url].blank? && !params[:lang].blank? && check_language_enabled(params[:lang]) 
      # When language is present in url but not the page (i.e. /en or /it)
      # Redirect to home page of specified language
      lang_home = yard_home(params[:lang])
      redirect_to get_yard_url(lang_home.id), :status => 301 
    when !params[:page_url].blank? && !params[:lang].blank? && check_language_enabled(params[:lang])
      # When both language and page are in url (i.e. /en/products)
      # Look for the page requested
      splitted_page_url = params[:page_url].split('/')
      @page = Page.where(:pretty_url => splitted_page_url.last).first
      if @page && @page.is_reserved? && (current_user.nil? || !current_user.is_privileged?)
        # If page is reserved and user is not authorized
        # Render unauthorized page error
        render_error('401')
      elsif @page && @page.published && check_path(@page, splitted_page_url) && check_language_enabled(@page.lang)
        # If everything goes green, fill the instance variables
        @meta_title = "#{@page.meta_title} - #{@cfg.site_page_title}".truncate(70, :omission => '')
        @meta_description = "#{@page.meta_description}".truncate(140, :omission => '')
        @meta_keywords = "#{@page.meta_keywords}"
        @hp = yard_home(@page.lang)
        lay = Layout.find(@cfg.theme_name, @page.layout_name).path
        render :layout => lay
      else
        # Page not found
        render_error('404')
      end
    else
      render_error('404')
    end #case
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
