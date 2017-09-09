module Rack
  # Rack::SearchSuggestions - intercept requests for the 'search_suggestions' endpoint
  # and respond with suggestions for the given 'term' parameter.
  class SearchSuggestions
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['PATH_INFO'] == '/search_suggestions'
        request = Rack::Request.new(env)
        searched_term = request.params['term']
        terms = []

        if searched_term.present?
          terms = RedisDb::SearchSuggestionsQuery.by_term(searched_term)
        end

        [200, { 'Content-Type' => 'application/json' }, [terms.to_json]]
      else
        @app.call(env)
      end
    end
  end
end
