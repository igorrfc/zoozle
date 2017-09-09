class Redis::IndexSearchWorker
  include Sidekiq::Worker

  def perform(description)
    Search.transaction do
      Search.create(description: description, popularity: 1)
      Redis::IndexSearch.process(description)
    end
  end
end
