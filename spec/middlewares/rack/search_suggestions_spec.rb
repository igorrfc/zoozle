require 'rails_helper'
require 'sidekiq/testing'

describe Rack::SearchSuggestions do
  let(:app) { proc { [200, {}, []] } }
  let(:stack) { Rack::SearchSuggestions.new(app) }
  let(:request) { Rack::MockRequest.new(stack) }

  describe '.call' do
    context 'when the request path is search_suggestions' do
      let(:response) { request.get("/search_suggestions?term=#{term}") }

      context 'when the term is not empty' do
        let(:term) { 'foo' }

        context 'and there is suggestions for the term received as param' do
          it 'returns the suggestions array' do
            Sidekiq::Testing.inline! do
              Searches::Processor.call('foo description', remote_ip: 'http://remote-ip.com')
            end

            response_body = JSON.parse(response.body)
            expect(response_body.first).to eq('foo description')
          end
        end

        context 'and there is no suggestions for the term received as param' do
          it 'returns an empty array' do
            response_body = JSON.parse(response.body)
            expect(response_body).to be_empty
          end
        end
      end

      context 'when the term is empty' do
        let(:term) { '' }

        it 'returns an empty array' do
          response_body = JSON.parse(response.body)
          expect(response_body).to be_empty
        end
      end
    end

    context 'when the request path is not search_suggestions' do
      it 'does not call the RedisDb::SearchSuggestionsQuery' do
        expect(RedisDb::SearchSuggestionsQuery)
          .to_not receive(:by_term)

        request.get('/another_search_suggestions?term=foo')
      end
    end
  end
end
