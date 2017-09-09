module Searches
  # Redis::IndexSearch - handles the search creation and/or its popularity increasement.
  class Processor
    attr_reader :description, :search, :remote_ip

    def initialize(description, remote_ip)
      @description = description.downcase
      @search = Search.where(description: @description)
      @remote_ip = remote_ip
    end

    def self.call(description, remote_ip:)
      new(description, remote_ip).call
    end

    def call
      return add_location_and_increment_popularity! if search.exists?

      RedisDb::IndexSearchWorker.perform_async(description, remote_ip)
    end

    private

    def add_location_and_increment_popularity!
      search_record = search.first
      search_record.increment(:popularity)
      search_record.locations.push(Location.new(ip: remote_ip))
      search_record.save
    end
  end
end
