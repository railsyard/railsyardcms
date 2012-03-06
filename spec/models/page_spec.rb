require 'spec_helper'

describe Page do

  describe "validations" do
    it "must have a :title with length >= 2" do
      Factory.build(:page, :title => "").should       have_errors_on(:title)
      Factory.build(:page, :title => "d").should      have_errors_on(:title)
      Factory.build(:page, :title => "du").should_not have_errors_on(:title)
    end

    it "must have a unique :pretty_url" do
      Factory.create(:page, :pretty_url => "bar")
      Factory.build(:page, :pretty_url => "").should    have_errors_on(:pretty_url)
      Factory.build(:page, :pretty_url => "bar").should have_errors_on(:pretty_url)
    end

    it "must have a :lang associated" do
      Factory.build(:page, :lang => "").should have_errors_on(:lang)
    end
  end

  describe "published/draft scopes" do

    let!(:published_page) { Factory.create(:page, :published => true)  }
    let!(:draft_page)     { Factory.create(:page, :published => false) }

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

  describe "#for_language" do
    it "filters pages not in the requested language" do
      it_page = Factory.create(:page, :lang => "it")
      en_page = Factory.create(:page, :lang => "en")

      it_pages = Page.for_language(:it)
      it_pages.should include it_page
      it_pages.should_not include en_page
    end
  end

  describe "#not_reserved" do
    it "filters reserved pages" do
      reserved_page = Factory.create(:page, :reserved => true)
      non_reserved_page1 = Factory.create(:page, :reserved => false)
      non_reserved_page2 = Factory.create(:page, :reserved => nil)

      non_reserved_pages = Page.not_reserved
      non_reserved_pages.should include non_reserved_page1
      non_reserved_pages.should include non_reserved_page2
      non_reserved_pages.should_not include reserved_page
    end
  end

  describe "#without_roots" do
    it "filters root pages" do
      root_page = Factory.create(:page, :ancestry => nil)
      non_root_page = Factory.create(:page, :parent => root_page)

      non_root_pages = Page.without_roots
      non_root_pages.should include non_root_page
      non_root_pages.should_not include root_page
    end
  end

end
