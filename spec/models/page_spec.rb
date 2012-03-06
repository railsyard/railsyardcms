require 'spec_helper'

describe Page do

  describe "scope" do
    describe "#published" do
      it "filters unpublished pages" do
        published_page = Factory.create(:page, :published => true)
        unpublished_page = Factory.create(:page, :published => false)

        published_pages = Page.published
        published_pages.should include published_page
        published_pages.should_not include unpublished_page
      end
    end
  end

end
