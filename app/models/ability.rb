class Ability
  include CanCan::Ability

  def initialize(user) 
    user ||= User.new # guest user (not logged in)
    if user.role? :admin
      can :manage, :all
    elsif user.role? :article_writer
      can :manage, [Article]
      can :read, [Page, User, Setting, ArticleLayout]
    elsif user.role? :premium_user
      can :read, [Article, Page, User, Setting, ArticleLayout]
    else
      can :read, Article do |art|
        !article.reserved
      end
      can :read, [Page, User, Setting, ArticleLayout]
    end
  end
  
end
