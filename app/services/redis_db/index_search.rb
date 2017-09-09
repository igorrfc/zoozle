module RedisDb
  # Redis::IndexSearch - concerns to index the terms of a search query on the redis db
  class IndexSearch
    attr_reader :search_description

    def initialize(search_description)
      @search_description = search_description
    end

    def self.process(search_description)
      new(search_description).process
    end

    def process
      index_term(search_description)
      search_description.split.each { |term| index_term(term) }
    end

    private

    def index_term(term)
      1.upto(term.length - 1) do |t|
        prefix = term[0, t]
        RedisDb::CONN.zincrby "#{RedisDb::SEARCH_SUGGESTIONS}:#{prefix.downcase}", 1, term.downcase
      end
    end
  end
end
