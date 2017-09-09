require 'rails_helper'
require 'sidekiq/testing'

describe RedisDb::IndexSearchWorker do
  describe '.perform' do
    let(:remote_ip) { 'http://remote-ip.com' }

    subject { RedisDb::IndexSearchWorker.perform_async('foo description', remote_ip) }

    it 'creates a job' do
      Sidekiq::Testing.fake!

      expect { subject }
        .to change(RedisDb::IndexSearchWorker.jobs, :size).by(1)
    end

    it 'creates a new Search model' do
      Sidekiq::Testing.inline!

      expect { subject }
        .to change(Search, :count).by(1)
    end

    it 'creates an associated location for the search model' do
      Sidekiq::Testing.inline!

      expect { subject }
        .to change(Location, :count).by(1)
      expect(Location.count).to eq 1
      expect(Location.first.ip).to eq remote_ip
    end

    it 'calls the Redis::IndexSearch for the created model description' do
      allow(RedisDb::IndexSearch).to receive(:process)

      expect(RedisDb::IndexSearch)
        .to receive(:process).with('foo description')

      Sidekiq::Testing.inline! { subject }
    end
  end
end
