RSpec::Matchers.define :have_errors_on do |attribute|

  @message = nil

  chain :with_message do |message|
    @message = message
  end

  match do |model|
    model.valid?

    errors = model.errors[attribute.to_sym]

    if @message
      errors.any? && errors.include?(@message)
    else
      errors.any?
    end
  end

  failure_message_for_should do |model|
    if @message
      "Validation errors #{model.errors[attribute.to_sym].inspect} should include #{@message.inspect}"
    else
      "#{model.class} should have errors on attribute #{attribute.inspect}"
    end
  end

  failure_message_for_should_not do |model|
    "#{model.class} should not have an error on attribute #{attribute.inspect}"
  end
end
