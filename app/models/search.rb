# Search - represents the searches made for application's resources
class Search < ApplicationRecord
  has_many :locations
end
