require 'rails_helper'

describe Location, type: :model do
  describe 'associaions' do
    it { is_expected.to belong_to(:search) }
  end
end
