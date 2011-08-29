class MenuCell < Cell::Rails
  include Yard
  helper_method :yard_home, :get_lang, :get_yard_url, :get_article_url # coming from lib/yard
  
  def first_level(args)
    @page = args[:page]
    @page = yard_home if @page.blank?
    @first_level_pages = yard_home.siblings
    @snip_id = args[:snip_id]
    @options = args[:options]
    fill_menu_variables(@page)
    render
  end

  def two_levels(args)
    @page = args[:page]
    @page = yard_home if @page.blank?
    @first_level_pages = yard_home.siblings
    @snip_id = args[:snip_id]
    @options = args[:options]
    fill_menu_variables(@page)
    render
  end

  def siblings(args)
    @page = args[:page]
    @page = yard_home if @page.blank?
    fill_menu_variables(@page)
    @snip_id = args[:snip_id]
    @options = args[:options]
    render
  end

  def children(args)
    @page = args[:page]
    @page = yard_home if @page.blank?
    fill_menu_variables(@page)
    @options = args[:options]
    @snip_id = args[:snip_id]
    render
  end

  def siblings_and_children(args)
    @page = args[:page]
    @options = args[:options]
    @page = yard_home if @page.blank?
    fill_menu_variables(@page)
    @snip_id = args[:snip_id]
    render
  end

  def footer(args)
    @page = args[:page]
    @page = yard_home if @page.blank?
    @first_level_pages = yard_home.siblings
    fill_menu_variables(@page)
    @options = args[:options]
    @snip_id = args[:snip_id]
    render
  end
  
  def nav(args)
    @page = args[:page]
    @page = yard_home if @page.blank?
    @ancestors = @page.ancestors
    @options = args[:options]
    @ancestors << @page
    @snip_id = args[:snip_id]
    render
  end
  
  private
  
  def fill_menu_variables(page)
    @current_level_pages = @page.siblings
    @family_pages_ids = [@page.id] #parents and sons, no siblings
    @family_pages_ids << @page.ancestors.map{|a| a.id}
    @family_pages_ids = @family_pages_ids.compact.flatten   
  end


end
