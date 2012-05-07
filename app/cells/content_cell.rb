class ContentCell < Cell::Rails
  include Yard
  helper_method :yard_home, :get_lang, :get_yard_url, :get_article_url # coming from lib/yard
  include Devise::Controllers::Helpers
  helper_method :current_user
  include Cell::Filters
  before_filter :fill_generic_variables

  ## Before filter not working as 'args' is unavailable in the filter
  # before_filter {|controller| controller.fill_generic_variables(args[:page], args[:options], args[:snip_id]) }

  def text_widget(args)
    render
  end

  def rich_text_widget(args)
    render
  end

  def articles_list(args)
    @articles = Article.published.where(:lang => get_lang).includes(:categorizations)
    @articles = @articles.not_reserved unless (args[:current_user] && args[:current_user].is_privileged?)

    if params[:category].blank?
      # show all configured categories
      @meta_title = I18n.t 'public.articles.all_categories'
      @articles = @articles.where("categorizations.category_id IN (?)", args[:options][:categories]) if args[:options][:categories]
    else
      # show only current category
      category = Category.find_by_pretty_url( params[:category] )
      if category
        @meta_title = I18n.t 'public.articles.category', :name => category.name
        @articles = @articles.joins(:categories).where( "categories.pretty_url = ?", params[:category] )
      end
    end

    unless params[:author].blank?
      author = User.find_by_pretty_url( params[:author] )
      if author
        @meta_title = I18n.t 'public.articles.author', :name => author.name
        @articles = @articles.joins(:user).where( "users.pretty_url" => params[:author])
      end
    end

    per_page = ( args[:options][:per_page].blank? )? 10 : args[:options][:per_page]
    @articles = @articles.paginate( :page => params[:page], :per_page => per_page )

    render
  end

  def articles_categories_list(args)
    @categories = Category.all_published
    @url = args[:options][:archive_url]
    render
  end

  def articles_authors_list(args)
    @authors = User.active_writers
    @url = args[:options][:archive_url]
    render
  end

  def twitter_stream(args)
    render
  end

  def downloads_widget(args)
    @snippet = Snippet.find(args[:snip_id])
    @downloads = @snippet.uploads
    render
  end

  def image_gallery_widget(args)
    @snippet = Snippet.find(args[:snip_id])
    @images = Image.where(:attachable_type => "Snippet", :attachable_id => @snippet.id)
    render
  end

  private

  def fill_generic_variables(state, opts)
    @page = opts[:page] ||= yard_home
    @options = opts[:options] ||= {}
    @snip_id = opts[:snip_id]
    @cfg = cfg
    @current_user = opts[:current_user]
  end

  def cfg
    Setting.first
  end

end
