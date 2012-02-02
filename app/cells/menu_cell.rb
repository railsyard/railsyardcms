class MenuCell < Cell::Rails
  include Yard
  helper_method :yard_home, :get_lang, :get_yard_url, :get_article_url # coming from lib/yard
  include Devise::Controllers::Helpers
  helper_method :current_user
  include Cell::Filters
  before_filter :fill_generic_variables
  before_filter :fill_menu_variables
  
  def first_level(args)
    @first_level_pages = yard_home(@page.lang).siblings 
    render
  end

  def two_levels(args)
    @first_level_pages = yard_home(@page.lang).siblings
    render
  end

  def siblings(args)
    render
  end

  def children(args)
    render
  end

  def siblings_and_children(args)
    render
  end

  def footer(args)
    @first_level_pages = yard_home(@page.lang).siblings 
    render
  end
  
  def nav(args)
    @ancestors = @page.ancestors
    @ancestors << @page
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
  
  def fill_menu_variables(state, opts)
    @page = opts[:page] ||= yard_home
    @current_level_pages = @page.siblings
    @family_pages_ids = [@page.id] #parents and sons, no siblings
    @family_pages_ids << @page.ancestors.map{|a| a.id}
    @family_pages_ids = @family_pages_ids.compact.flatten   
  end

  def cfg
    Setting.first
  end


end
