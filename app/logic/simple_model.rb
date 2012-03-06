module SimpleModel
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    class_attribute :model_attributes
    validates :identifier, presence: true
  end

  module ClassMethods

    def attributes(*attributes)
      attr_reader *attributes
      self.model_attributes ||= [ :identifier ]
      self.model_attributes += attributes.each(&:to_sym)
    end

    def load(path)
      new YAML.load_file(path)
    end

  end

  attr_reader :identifier

  def initialize(attributes = {})
    attributes = attributes.clone
    attributes.symbolize_keys!
    attributes.assert_valid_keys(*self.class.model_attributes)
    self.class.model_attributes.each do |attribute|
      instance_variable_set "@#{attribute}", attributes[attribute]
    end
  end

end
