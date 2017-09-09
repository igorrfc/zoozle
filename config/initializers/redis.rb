module RedisDb
  CONN = Rails.env.production? ? Redis.new(url: ENV['REDIS_URL']) : Redis.new
  SEARCH_SUGGESTIONS = 'search_suggestions'
end
