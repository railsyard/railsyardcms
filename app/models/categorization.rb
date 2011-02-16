class Categorization < ActiveRecord::Base
  belongs_to :article
  belongs_to :category
  belongs_to :tag
  belongs_to :snippet
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)