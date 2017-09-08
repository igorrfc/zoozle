require 'rails_helper'

describe Search, type: :model do
  describe 'associaions' do
    it { is_expected.to have_many(:locations) }
  end
end
