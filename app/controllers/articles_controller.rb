class ArticlesController < ApplicationController
  
  def show
    @cfg = cfg
    @article = Article.find(:first, :conditions => ["pretty_url = ?", params[:pretty_url]])
    @meta_title = @article.meta_title.blank? ? "#{@article.title} - #{@cfg.site_name} #{@cfg.site_page_title}" : "#{@article.title} - #{@article.meta_title} - #{@cfg.site_name} #{@cfg.site_page_title}"
    @meta_desc = @article.meta_desc.blank? ? "#{@cfg.site_desc}" : "#{@article.meta_desc} - #{@cfg.site_desc}"
    @meta_keyword = @article.meta_keyword.blank? ? "#{@cfg.site_keywords}" : "#{@article.meta_keyword}, #{@cfg.site_keywords}"
    @article_layout = ArticleLayout.find_by_lang(@article.lang)
    
    if check_path(@article) && check_permission(@article, current_user)
      render :layout => Layout.find(@cfg.theme_name, @article_layout.layout_name).path 
    else
      render_error('404')
    end
  end
  
  private
  
  def check_path(article)
    article.publish_at.year == params[:year].to_i && article.publish_at.month == params[:month].to_i && article.publish_at.day == params[:day].to_i && article.lang == get_lang
  end
  
  def check_permission(article, user)
    true unless article.reserved && (user.nil? or (!user.nil? && !user.is_privileged?))
  end
  
end
