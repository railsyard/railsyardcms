class CategoriesController < ApplicationController

  def show
    @layout = ArticleLayout.find_by_lang( params[:lang] )
    @category = Category.where( :pretty_url => params[:pretty_url] ).first
    @articles = @category.articles.select do |a|
      check_permission(a, current_user) && check_publish_status(a)
    end
    @meta_title = "#{I18n.t('admin.general.category')} #{@category.name}"

    render :layout => Layout.find(@cfg.theme_name, @layout.layout_name).path
  end

private

  def check_publish_status(article)
    true if article.published && (article.publish_at < Time.zone.now)
  end

  def check_permission(article, user)
    true unless article.reserved && (user.nil? or (!user.nil? && !user.is_privileged?))
  end

end
