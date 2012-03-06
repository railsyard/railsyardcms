class Theme

  class Invalid < RuntimeError; end
  class NotFound < RuntimeError; end

  include SimpleModel
  attributes :title, :description, :author

  validates :title, presence: true

  def self.load(path)
    config = YAML.load_file(path)
    config.symbolize_keys!
    layouts = config.delete(:layouts)
    identifier = File.basename(File.dirname(path))
    config.reverse_merge!(:identifier => identifier)
    Theme.new(config)
  end

  def self.all
    available_theme_directories.map do |theme_path|
      theme = Theme.load(File.join(theme_path, "theme_conf.yml"))
      raise Theme::Invalid unless theme.valid?
      theme
    end
  end

  def self.find!(identifier)
    Theme.all.find do |theme|
      theme.identifier.to_sym == identifier.to_sym
    end or raise Theme::NotFound
  end

  private

  def self.available_theme_directories(path = Rails.root.join("themes"))
    Dir[File.join(path, '*/')].select do |theme_path|
      File.readable?(File.join(theme_path, "theme_conf.yml"))
    end.compact.uniq
  end

end
