module RedisDb
  # RedisDb::SearchSuggestionsQuery - filter redis keysets values with the search suggestions namespace
  class SearchSuggestionsQuery
    class << self
      def by_term(term)
        RedisDb::CONN.zrevrange "#{RedisDb::SEARCH_SUGGESTIONS}:#{term.downcase}", 0, 9
      end
    end
  end
end
