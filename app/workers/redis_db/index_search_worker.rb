module RedisDb
  # RedisDb::IndexSearchWorker - handles the search creation and its indexing on redis.
  class IndexSearchWorker
    include Sidekiq::Worker

    def perform(description, remote_ip)
      Search.transaction do
        Search.create(
          description: description,
          popularity: 1,
          locations: [Location.new(ip: remote_ip)]
        )

        RedisDb::IndexSearch.process(description)
      end
    end
  end
end
