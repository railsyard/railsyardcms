class Theme

  class Invalid < RuntimeError
    def initialize(theme)
      @theme = theme
    end
    def message
      description = @theme.errors.full_messages.join(", ")
      "Theme \"#{@theme.identifier}\" is invalid: #{description}"
    end
  end

  class NotFound < RuntimeError
    def message
      "Cannot find theme \"#{super}\""
    end
  end

  class LayoutNotFound < RuntimeError
    def message
      "Cannot find layout \"#{super}\""
    end
  end

  include SimpleModel
  attributes :title, :description, :author, :layouts

  validates :title, :presence => true
  validate :valid_layouts

  attr_reader :layouts

  def self.load(path)
    config = YAML.load_file(path)
    config.symbolize_keys!
    identifier = File.basename(File.dirname(path))
    config.reverse_merge!(:identifier => identifier)
    Theme.new(config)
  end

  def self.all
    available_theme_directories.map do |theme_path|
      theme = Theme.load(File.join(theme_path, "theme_conf.yml"))
      unless theme.valid?
        raise Theme::Invalid.new(theme)
      end
      theme
    end
  end

  def self.find!(identifier)
    Theme.all.find do |theme|
      theme.identifier.to_sym == identifier.to_sym
    end or raise Theme::NotFound.new(identifier)
  end

  def initialize(attributes = {})
    super(attributes)
    @layouts = @layouts.map do |layout_conf|
      Layout.new(layout_conf)
    end if @layouts.present?
  end

  def find_layout!(identifier)
    layouts.find do |layout|
      layout.identifier.to_sym == identifier.to_sym
    end or raise Theme::LayoutNotFound.new(identifier)
  end

  private

  def self.available_theme_directories(path = Rails.root.join("app/assets/themes"))
    Dir[File.join(path, '*/')].select do |theme_path|
      File.readable?(File.join(theme_path, "theme_conf.yml"))
    end
  end

  def valid_layouts
    if layout = layouts.find { |layout| layout.invalid? }
      description = layout.errors.full_messages.join(", ")
      errors.add(:base, "Layout \"#{layout.identifier}\" is invalid: #{description}")
    end
  end

end
