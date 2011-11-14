class Language 
  attr_reader :path, :short, :name, :version
  
  # path = absolute file path on filesystem
  # short = filename without the .yml extension i.e: it, en, fr
  # name = full language name, read from the yaml file i.e: Italiano, English, Francais
  # version = version of translation file, read from the yaml file i.e: 1.0.0
  def initialize(path, short, name, version)
    @path, @short, @name, @version = path, short, name, version
  end
  
  def self.all
    languages = []
    search_languages.map do |lang_path|
      file_read = YAML.load_file(lang_path)
      short = lang_path.split('/').last.split('.').first
      languages << self.new(lang_path,
                            short,
                            file_read[short]["conf"]["language_extended_name"],
                            file_read[short]["conf"]["version"]) if (file_read[short] && 
                                                                     file_read[short]["conf"] &&
                                                                     file_read[short]["conf"]["language_extended_name"] && 
                                                                     file_read[short]["conf"]["version"])
    end
    languages.compact.uniq.keep_if {|l| l.short =~ $AVAILABLE_LANGUAGES}
  end
  
  def self.all_short
    all.map{|l| l.short}.compact.uniq
  end
  
  def self.find(short)
    all.select{|l| l.short.eql? short.to_s}.first unless short =~ $AVAILABLE_LANGUAGES
  end
  
  def self.search_languages
    languages_path = "#{Rails.root.to_s}/config/locales/*.yml"
    Dir.glob(languages_path).select do |file|
      File.readable?("#{file}")
    end.compact.uniq
  end
  
end
