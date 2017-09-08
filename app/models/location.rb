# Location - represents the location(ip address) which the search were made
class Location < ApplicationRecord
  belongs_to :search
end
