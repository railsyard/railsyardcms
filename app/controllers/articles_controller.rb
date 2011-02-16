class ArticlesController < ApplicationController
  
  layout :set_layout
  
  def index
    restriction = (current_user.nil? || !current_user.is_privileged?) ? " AND reserved = false" : ""
    if params[:categories].blank?
      @articles = Article.published.paginate  :all,
                                              :conditions => ["lang = ? #{restriction}", get_lang],
                                              :order => "publish_at DESC",
                                              :page => params[:pagination]
    else
      @articles = Article.published.paginate  :all,
                                              :include  => [:categorizations], # eager loading!
                                              :conditions => ["lang = ? AND categorizations.category_id IN (?) #{restriction}", get_lang, params[:categories].join(',')],
                                              :order => "articles.publish_at DESC",
                                              :page => params[:pagination]
    end
    respond_to do |format|
      format.html{
        logger.error("404 displayed")
        render(:file => "#{RAILS_ROOT}/public/404.html", :status	=> "404 Not Found")
      }
      format.js {
        render :update do |page|  
          page.replace("articles-list", :file => "articles/index.html.erb", :object => @articles)
        end
      }
      format.embedded { #Embedded action
        render :file => "articles/index.html.erb", :layout => false
      } 
    end
  end
  
  def show
    @article = Article.find(:first, :conditions => ["pretty_url = ?", params[:pretty_url]])
    if @article.publish_at.year == params[:year].to_i && @article.publish_at.month == params[:month].to_i && @article.publish_at.day == params[:day].to_i
      set_default_variables(@article)
      render :layout => set_layout
    else
      logger.error("404 displayed")
      render(:file => "#{RAILS_ROOT}/public/404.html", :status	=> "404 Not Found")
    end
  end
  
  # only for embedded action - Last article snippet
  def last
    @article = Article.find :first,
                            :include  => [:categorizations],
                            :conditions => ["reserved = ? AND lang = ? AND categorizations.category_id IN (?)", false, get_lang, params[:categories].join(',')],
                            :order => "publish_at DESC"         
    if @article
      set_default_variables(@article)
      respond_to do |format|
        format.html{
          logger.error("404 displayed")
          render(:file => "#{RAILS_ROOT}/public/404.html", :status	=> "404 Not Found")
        }
        format.js {
          logger.error("404 displayed")
          render(:file => "#{RAILS_ROOT}/public/404.html", :status	=> "404 Not Found")
        }
        format.embedded { #Embedded action
          render :partial => "articles/item.html.erb", :object => @article
        } 
      end
    else
      logger.error("404 displayed")
      render(:file => "#{RAILS_ROOT}/public/404.html", :status	=> "404 Not Found")
    end
  end
    
  def carousel
    restriction = (current_user.nil? || !current_user.is_privileged?) ? " AND reserved = false" : ""
    if params[:categories].blank?
      @articles = Article.published.find  :all,
                                          :conditions => ["lang = ? #{restriction}", get_lang],
                                          :order => "publish_at DESC",
                                          :limit => 9
    else
      @articles = Article.published.find  :all,
                                          :include  => [:categorizations], # eager loading!
                                          :conditions => ["lang = ? AND categorizations.category_id IN (?) #{restriction}", get_lang, params[:categories].join(',')],
                                          :order => "articles.publish_at DESC",
                                          :limit => 9
    end
    respond_to do |format|
      format.html{
        logger.error("404 displayed")
        render(:file => "#{RAILS_ROOT}/public/404.html", :status	=> "404 Not Found")
      }
      format.js {
        logger.error("404 displayed")
        render(:file => "#{RAILS_ROOT}/public/404.html", :status	=> "404 Not Found")
      }
      format.embedded { #Embedded action
        render :file => "articles/carousel.html.erb", :layout => false
      } 
    end
  end
  
  private
  
  def set_default_variables(article)
    @cfg = cfg
    @hp = yard_home
    @meta_title = "#{article.title} - #{@cfg.site_name} #{@cfg.site_page_title}"
    @meta_desc = "#{article.title} - #{@cfg.site_desc}"
    @meta_keyword = "#{@cfg.site_keyword}"
    @first_level_pages = @hp.self_and_siblings.for_language(get_lang)  
  end
  
  def set_layout
    Layout.find(@cfg.theme_name, 'article').path
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)