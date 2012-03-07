require 'spec_helper'

describe SimpleModel do

  before do
    class SimpleModelTest
      include SimpleModel
      attributes :foo, :bar
    end
  end

  describe ".initialize" do
    it "accepts and returns specified attributes" do
      test = SimpleModelTest.new(foo: "val1", bar: "val2")
      test.foo.should == "val1"
      test.bar.should == "val2"
    end

    it "raises an exception on unknown attributes" do
      lambda {
        SimpleModelTest.new(unknown_attribute: "val")
      }.should raise_error
    end
  end

  describe "#load" do
    it "initialize a new model from Yaml file" do
      test = SimpleModelTest.load(Rails.root.join("spec/fixtures/simple_model_test.yml"))
      test.foo.should == "one"
    end
  end

  it "requires an :identifier" do
    SimpleModelTest.new.should have_errors_on(:identifier)
  end

end
