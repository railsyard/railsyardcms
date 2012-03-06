require 'spec_helper'

describe Page do

  describe "published/draft scopes" do

    let!(:published_page) { Factory.create(:page, :published => true) }
    let!(:draft_page) { Factory.create(:page, :published => false) }

    describe "#published" do
      it "filters draft pages" do
        published_pages = Page.published
        published_pages.should include published_page
        published_pages.should_not include draft_page
      end
    end

    describe "#drafts" do
      it "filters published pages" do
        published_pages = Page.drafts
        published_pages.should_not include published_page
        published_pages.should include draft_page
      end
    end

  end

end
