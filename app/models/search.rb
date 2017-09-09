# Search - represents the searches made for application's resources
class Search < ApplicationRecord
  has_many :locations

  scope :by_popularity, -> { order(popularity: :desc) }
end
