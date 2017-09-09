module RedisDb
  # RedisDb::IndexSearchWorker - handles the search creation and its indexing on redis.
  class IndexSearchWorker
    include Sidekiq::Worker

    def perform(description)
      Search.transaction do
        Search.create(description: description, popularity: 1)
        RedisDb::IndexSearch.process(description)
      end
    end
  end
end
