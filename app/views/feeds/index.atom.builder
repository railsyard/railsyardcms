atom_feed do |feed|
  feed.title(@title)

  feed.updated(@updated)

  @articles.each do |article|
    feed.entry(article, :url => get_article_url(article)) do |entry|
      
      entry.title(h(article.title))
      entry.summary(strip_tags(article.short))

      entry.author do |author|
        author.name("#{article.user.firstname} #{article.user.lastname}")
      end
    end
  end
end