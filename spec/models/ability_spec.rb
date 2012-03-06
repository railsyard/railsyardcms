require 'spec_helper'
require "cancan/matchers"

describe Ability do

  subject { Ability.new(user) }

  context "when an article writer is logged" do
    let(:user) { Factory.create(:article_writer) }

    it { should be_able_to :manage, Article }
    it { should be_able_to :manage, Category }
    it { should be_able_to :manage, ArticleLayout }
    it { should be_able_to :manage, Comment }

    it { should be_able_to :read, Page }
    it { should_not be_able_to :create, Page }
    it { should_not be_able_to :update, Page }
  end

end

