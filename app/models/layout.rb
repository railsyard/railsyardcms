class Layout
  extend ActiveSupport::Memoizable
  attr_reader :title, :filename, :path, :areas
  
  ## Exception Handling
  class LayoutNotFound < StandardError
  end
  class LayoutsLocatorError < StandardError
  end
  
  # title = descriptive title
  # filename = filename with extension
  # path = absolute path on filesystem
  def initialize(title, filename, path, areas)
    @title, @filename, @path, @areas = title, filename, path, areas
  end
  
  # Thats the only way to memoize class methods (self methods)
  class << self
    extend ActiveSupport::Memoizable
    
    def all(theme_name)
      begin
        theme = Theme.find(theme_name)
        theme_conf = YAML.load_file("#{theme.path}/theme_conf.yml")
        layouts = []
        theme_conf["layouts"].map do |lay|
          layouts << self.new(lay["title"], lay["filename"], "#{theme.path}/views/layouts/#{lay["filename"]}", lay["areas"])
        end
        layouts.compact.flatten.uniq
      rescue Exception => exc
         Rails.logger.error("***************** Error with layouts locator *****************")
         raise LayoutsLocatorError
      end
    end
    memoize :all
    
    def find(theme, filename) 
      begin
        lay = all(theme.to_s).select{|t| t.filename.eql? filename.to_s}.first
        raise LayoutNotFound if lay.nil?
        lay
      rescue Exception => exc
         Rails.logger.error("***************** Error locating layout *****************")
         raise LayoutNotFound
      end
    end
    memoize :find
    
  end
  
end
