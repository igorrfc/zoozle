class Redis::IndexSearch
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
      $redis.zincrby "#{$REDIS_SEARCH_SUGGESTIONS}:#{prefix.downcase}", 1, term.downcase
    end
  end
end
