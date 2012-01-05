Factory.define :article do |article|
  article.lang 'en'
  article.reserved false
  article.published true
  article.pretty_url { Factory.next(:article_pretty_url) }
  article.publish_at Time.new
end


Factory.sequence :article_pretty_url do |n|
  "article-#{n}"
end

Factory.define :categorization do |assoc|
  
end

Factory.define :article_layout do |al|
  al.lang 'en'
  al.layout_name 'single_column.html.erb'
end
