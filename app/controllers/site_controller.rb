class SiteController < ApplicationController
  layout "site" # default layout 

  def spawn
    @cfg = cfg # get global configuration, see application controller
    @hp = yard_home

    if params[:page_url].blank? && params[:lang].blank?
      redirect_to yard_home_link
    elsif params[:page_url].blank? && !params[:lang].blank?
      lang_home = Page.roots.find(:first, :order => "position ASC", :conditions => ["lang = ?", params[:lang]])
      redirect_to get_yard_url(lang_home.id, :options => {:lang => params[:lang]})
    else
      page_url = params[:page_url]
      @pg = Page.find(:first, :conditions => ["pretty_url = ?", page_url.last]) unless page_url.last.nil?
      if @pg && @pg.is_reserved? && (current_user.nil? || !current_user.is_privileged?)
        logger.error("401 displayed")
        render(:file	=> "#{RAILS_ROOT}/public/401.html", :status	=> "401 Unauthorized")
      elsif @pg && @pg.published && (@pg.lang == params[:lang])
        @meta_title = @pg.meta_title.blank? ? "#{@cfg.site_name} #{@cfg.site_page_title}" : "#{@pg.meta_title} - #{@cfg.site_name} #{@cfg.site_page_title}"
        @meta_desc = @pg.meta_desc.blank? ? "#{@cfg.site_desc}" : "#{@pg.meta_desc} #{@cfg.site_desc}"
        @meta_keyword = @pg.meta_keyword.blank? ? "#{@cfg.site_keyword}" : "#{@pg.meta_keyword}, #{@cfg.site_keyword}"
        
        # for menu snippets
        @first_level_pages = @hp.self_and_siblings.for_language(@pg.lang)
        @current_level_pages = @pg.self_and_siblings.for_language(@pg.lang)
        @family_pages_ids = [@pg.id] #parents and sons, no siblings
        @family_pages_ids << @pg.ancestors.map{|a| a.id}
        @family_pages_ids = @family_pages_ids.compact.flatten
        
        @layout_name = Layout.find(@cfg.theme_name, @pg.layout_name).path
        render :layout => @layout_name unless @layout_name.blank?
      else
        logger.error("404 displayed")
        render(:file	=> "#{RAILS_ROOT}/public/404.html", :status	=> "404 Not Found")
      end
    end
  end
  
  private
  
  

end
# Author::    Silvio Relli  (mailto:silvio@relli.org)