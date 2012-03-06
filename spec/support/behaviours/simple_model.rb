shared_examples_for "a SimpleModel" do

  let(:fake_attributes_values) do
    attrs = {}
    attributes.map(&:to_s).each_with_index do |attribute, index|
      attrs[attribute] = "attribute_#{index}"
    end
    attrs
  end

  describe ".initialize" do
    it "should accept and return attributes" do
      fake_values = fake_attributes_values
      model = subject.class.new(fake_values)

      attributes.each do |attribute|
        model.send(attribute).should == fake_values[attribute.to_s]
      end
    end
  end

end
