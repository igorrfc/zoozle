require 'rails_helper'
require 'sidekiq/testing'

describe Redis::IndexSearchWorker do
  describe '.perform' do
    it 'creates a job' do
      Sidekiq::Testing.fake!

      expect {
        Redis::IndexSearchWorker.perform_async('foo description')
      }.to change(Redis::IndexSearchWorker.jobs, :size).by(1)
    end

    it 'creates a new Search model' do
      Sidekiq::Testing.inline!

      expect {
        Redis::IndexSearchWorker.perform_async('foo description')
      }.to change(Search, :count).by(1)
    end

    it 'calls the Redis::IndexSearch for the created model description' do
      allow(Redis::IndexSearch).to receive(:process)

      expect(Redis::IndexSearch)
        .to receive(:process).with('foo description')

      Sidekiq::Testing.inline! do
        Redis::IndexSearchWorker.perform_async('foo description')
      end
    end
  end
end
