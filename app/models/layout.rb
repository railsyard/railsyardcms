class Layout
  
  attr_reader :path, :short, :name
  
  # path = absolute path on filesystem
  # short = filename without extension
  # name = filename with extension
  def initialize(path, short, name)
    @path, @short, @name = path, short, name
  end
  
  def self.all(theme)
    layouts = []
    search_layouts(theme.to_s).map do |layout_path|
      layouts << self.new(layout_path, File.basename("#{layout_path}").split('.')[0], File.basename("#{layout_path}"))
    end
    layouts.compact.uniq
  end
  
  def self.find(theme, short)
    all(theme.to_s).select{|t| t.short.eql? short.to_s}.first
  end
  
  def self.search_layouts(theme)
    layouts_path = "#{RAILS_ROOT}/themes/#{theme.to_s}/layouts/*"
    Dir.glob(layouts_path).select do |file|
      File.readable?("#{file}")
    end.compact.uniq
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)