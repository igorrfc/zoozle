require 'rails_helper'

describe Redis::IndexSearch do
  describe '.process' do
    let(:search_suggestions_namespace) { $REDIS_SEARCH_SUGGESTIONS }
    let(:sorted_sets) { $redis.keys("*#{search_suggestions_namespace}*") }

    before { Redis::IndexSearch.process('description') }

    it 'creates sorted sets with all variations of the description param' do
      expect(sorted_sets).to include(
        "#{search_suggestions_namespace}:d",
        "#{search_suggestions_namespace}:de",
        "#{search_suggestions_namespace}:des",
        "#{search_suggestions_namespace}:desc",
        "#{search_suggestions_namespace}:descr",
        "#{search_suggestions_namespace}:descri",
        "#{search_suggestions_namespace}:descrip",
        "#{search_suggestions_namespace}:descript",
        "#{search_suggestions_namespace}:descripti",
        "#{search_suggestions_namespace}:descriptio",
      )
    end

    it 'creates redis sorted sets pointing to the received description param' do
      sorted_keys_values = sorted_sets.map do |key|
        $redis.zrevrange(key, 0, 9).first
      end

      expect(
        sorted_keys_values.all? { |value| value == 'description' }
      ).to be_truthy
    end
  end
end
