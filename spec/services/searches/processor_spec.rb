require 'rails_helper'

describe Searches::Processor do
  describe '.call' do
    subject { described_class.call('foo description') }

    context 'when there is a search model with the description received as param' do
      let!(:search) { create(:search, description: 'foo description') }

      it "increments the search's popularity" do
        expect do
          subject
        end.to change { search.reload.popularity }.from(0).to(1)
      end
    end

    context 'when there is no search models with the description received as param' do
      it 'calls the RedisDb::IndexSearchWorker' do
        allow(RedisDb::IndexSearchWorker).to receive(:perform_async)

        expect(RedisDb::IndexSearchWorker)
          .to receive(:perform_async).with('foo description')

        subject
      end
    end
  end
end
