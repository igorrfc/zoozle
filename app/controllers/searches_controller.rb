class SearchesController < ApplicationController
  def index
    @searches = Search.by_popularity
  end
end
