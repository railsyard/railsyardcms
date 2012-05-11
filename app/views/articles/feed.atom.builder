atom_feed :language => params[:lang] do |feed|
  feed.title @title
  feed.updated @updated

  @articles.each do |item|
    next if item.updated_at.blank?
    url = URI.join( root_url, get_article_url(item) )

    feed.entry( item, :url => url ) do |entry|
      entry.url url
      entry.title item.title
      entry.content item.body, :type => 'html'

      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))

      entry.author do |author|
        author.name item.user.sign
      end
    end

  end
end
