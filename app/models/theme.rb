class Theme
  
  attr_reader :path, :short, :title, :description, :author
  
  # path = absolute theme directory path on filesystem
  # short = theme directory name, must be the same as the base_conf.short entry on the theme_conf.yaml file
  # title = base_conf.title entry on the theme_conf.yaml file
  # description = base_conf.description entry on the theme_conf.yaml file
  # author = base_conf.author entry on the theme_conf.yaml file
  def initialize(path, short, title, description, author)
    @path, @short, @title, @description, @author = path, short, title, description, author
  end
  
  def self.all
    themes = []
    search_themes.map do |theme_path|
      theme_conf = YAML.load_file("#{theme_path}/theme_conf.yml")
      themes << self.new(theme_path, theme_conf["base_conf"]["short"], theme_conf["base_conf"]["title"], theme_conf["base_conf"]["description"], theme_conf["base_conf"]["author"])
    end
    themes.compact.uniq
  end
  
  def self.find(short)
    all.select{|t| t.short.eql? short.to_s}.first
  end
  
  def self.search_themes
    themes_path = "#{RAILS_ROOT}/themes/[a-zA-Z0-9]*"
    Dir.glob(themes_path).select do |file|
      File.readable?("#{file}/theme_conf.yml")
    end.compact.uniq
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)