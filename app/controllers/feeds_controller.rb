class FeedsController < ApplicationController
  layout false

    def index
      @articles = Article.for_public_feed
      @title = "#{cfg.site_name} Feed"
      @updated = @articles.first.publish_at unless @articles.empty?
    end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)