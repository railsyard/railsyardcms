class MenuCell < Cell::Rails
  
  extend ActiveSupport::Memoizable
  include Yard
  helper_method :yard_home, :get_lang, :get_yard_url, :get_article_url # coming from lib/yard
  
  def first_level(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    fill_menu_variables(@page)
    @first_level_pages = yard_home.siblings 
    render
  end

  def two_levels(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    fill_menu_variables(@page)
    @first_level_pages = yard_home.siblings
    render
  end

  def siblings(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    fill_menu_variables(@page)
    render
  end

  def children(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    fill_menu_variables(@page)
    render
  end

  def siblings_and_children(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    fill_menu_variables(@page)
    render
  end

  def footer(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    fill_menu_variables(@page)
    @first_level_pages = yard_home.siblings 
    render
  end
  
  def nav(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    fill_menu_variables(@page)
    @ancestors = @page.ancestors
    @ancestors << @page
    render
  end
  
  private
  
  def fill_generic_variables(page, options, snip_id)
    @page = page ||= yard_home
    @options = options ||= {}
    @snip_id = snip_id
    @cfg = cfg
  end
  
  def fill_menu_variables(page)
    @current_level_pages = @page.siblings
    @family_pages_ids = [@page.id] #parents and sons, no siblings
    @family_pages_ids << @page.ancestors.map{|a| a.id}
    @family_pages_ids = @family_pages_ids.compact.flatten   
  end

  def cfg
    Setting.first
  end
  memoize :cfg


end
