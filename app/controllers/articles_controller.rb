class ArticlesController < ApplicationController

  def show
    @article = Article.find(:first, :conditions => ["pretty_url = ?", params[:pretty_url]])
    @article_layout = ArticleLayout.find_by_lang(@article.lang)
    @meta_title = "#{@article.meta_title} - #{@cfg.site_page_title}".truncate(70, :omission => '')
    @meta_description = "#{@article.meta_description}".truncate(140, :omission => '')
    @meta_keywords = "#{@article.meta_keywords}"
    if check_path(@article) && check_permission(@article, current_user) && check_publish_status(@article)
      render :layout => Layout.find(@cfg.theme_name, @article_layout.layout_name).path
    else
      render_error('404')
    end
  end

  def feed
    @title = "#{Setting.first.site_page_title} Blog"
    @articles = Article.published
    @updated = @articles.first.updated_at unless @articles.empty?

    respond_to do |format|
      format.atom { render :layout => false }
      format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
    end
  end

  private

  def check_path(article)
    article.publish_at.year == params[:year].to_i && article.publish_at.month == params[:month].to_i && article.publish_at.day == params[:day].to_i && article.lang == get_lang
  end

  def check_permission(article, user)
    true unless article.reserved && (user.nil? or (!user.nil? && !user.is_privileged?))
  end

  def check_publish_status(article)
    true if article.published && (article.publish_at < Time.zone.now)
  end

end
