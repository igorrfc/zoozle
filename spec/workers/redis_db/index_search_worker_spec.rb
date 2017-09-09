require 'rails_helper'
require 'sidekiq/testing'

describe RedisDb::IndexSearchWorker do
  describe '.perform' do
    it 'creates a job' do
      Sidekiq::Testing.fake!

      expect do
        RedisDb::IndexSearchWorker.perform_async('foo description')
      end.to change(RedisDb::IndexSearchWorker.jobs, :size).by(1)
    end

    it 'creates a new Search model' do
      Sidekiq::Testing.inline!

      expect do
        RedisDb::IndexSearchWorker.perform_async('foo description')
      end.to change(Search, :count).by(1)
    end

    it 'calls the Redis::IndexSearch for the created model description' do
      allow(RedisDb::IndexSearch).to receive(:process)

      expect(RedisDb::IndexSearch)
        .to receive(:process).with('foo description')

      Sidekiq::Testing.inline! do
        RedisDb::IndexSearchWorker.perform_async('foo description')
      end
    end
  end
end
