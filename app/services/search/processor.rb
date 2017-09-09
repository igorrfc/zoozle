class Search::Processor
  attr_reader :description, :search

  def initialize(description)
    @description = description.downcase
    @search = Search.where(description: @description)
  end

  def self.call(description)
    new(description).call
  end

  def call
    return increment_popularity! if search.exists?

    Redis::IndexSearchWorker.perform_async(description)
  end

  private

  def increment_popularity!
    search_record = search.first
    search_record.increment!(:popularity)
  end
end
