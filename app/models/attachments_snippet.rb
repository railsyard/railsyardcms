class AttachmentsSnippet < Snippet
  
  # Moved inside Snippet model as causing problems
  #has_many :assets, :as => :attachable, :dependent => :destroy
  #accepts_nested_attributes_for :assets
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)