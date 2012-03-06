require 'spec_helper'

describe Theme do

  it_behaves_like "a SimpleModel" do
    let(:attributes) { [ :identifier, :title, :description, :author ] }
  end

  describe "#all" do
    it "returns the available themes" do
      theme_path = "foo/bar/"
      theme = stub(:valid? => true)
      Theme.stubs(:available_theme_directories).returns([theme_path])
      Theme.stubs(:load).with("foo/bar/theme_conf.yml").returns(theme)
      Theme.all.should == [ theme ]
    end

    it "raises Theme::Invalid if one of the themes is not valid" do
      theme_path = "foo/bar/"
      theme = stub(:valid? => false)
      Theme.stubs(:available_theme_directories).returns([theme_path])
      Theme.stubs(:load).with("foo/bar/theme_conf.yml").returns(theme)
      lambda { Theme.all }.should raise_error Theme::Invalid
    end
  end

  describe "#find!" do
    it "returns the theme by identifier" do
      theme = stub(:identifier => "test")
      Theme.stubs(:all).returns([ theme ])
      Theme.find!(:test).should == theme
    end
    it "raises Theme::NotFound if cannot find it" do
      Theme.stubs(:all).returns([])
      lambda { Theme.find!(:test) }.should raise_error Theme::NotFound
    end
  end

  describe "#load" do
    it "initializes a new theme from a Yaml config file" do
      theme = stub
      theme_config = { "foo" => "bar", "layouts" => "boo" }
      YAML.stubs(:load_file).with("/path/config.yml").returns(theme_config)
      Theme.stubs(:new).with(:foo => "bar", :identifier => "path").returns(theme)
      Theme.load("/path/config.yml").should == theme
    end
  end

  describe "#available_theme_directories" do
    it "returns the available Railsyard themes" do
      Theme.publicize_methods do
        themes_container_path = Rails.root.join("spec/fixtures/themes")
        themes = Theme.available_theme_directories(themes_container_path)
        themes.map { |path| File.basename(path) }.should =~ ["foo", "bar"]
      end
    end
  end

  describe "acceptance on a valid theme Yaml configuration file" do
    it "should not throw validation problems" do
      theme = Theme.load(Rails.root.join("spec/fixtures/themes/bar/theme_conf.yml"))
      theme.should be_valid
      theme.title.should == "title"
      theme.author.should == "author"
      theme.description.should == "description"
    end
  end

end
