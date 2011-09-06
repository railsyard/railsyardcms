module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
  
  # Returns a page object for a given page url
  def page_for(page_url)
    lang, *splitted_page_url = page_url.split('/').reject { |i| i.empty? }
    page = Page.where(:pretty_url => splitted_page_url.last).first unless splitted_page_url.last.nil?
    acestors_and_self = (page.ancestors.map{|a| a.title.urlify} - [lang]) << page.title.urlify unless page.blank?
    url_and_page_ancestors_matching = splitted_page_url == acestors_and_self
    if page && (page.lang == lang) # && url_and_page_ancestors_matching
      return page
    else
      return nil
    end
  end
end

World(NavigationHelpers)
