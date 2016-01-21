require 'spec_helper'

describe Cash do
  describe 'configuration' do
    it 'cannot instanciate non-exisitng currency' do
      expect { Cash.new('EUR', 50) }.to raise_error(UnknownCurrencyError)
    end

    it 'can instanciate a known currency' do
      Cash.conversion_rates('EUR', {
        'USD' => 1.11,
        'Bitcoin' => 0.0047
      })
      expect(Cash.new('EUR', 50)).to be_a(Cash)
    end

    it 'fails if exchange rate is 0' do
      expect { Cash.conversion_rates('USD', {'DKK' => 0})}
    end
  end

  describe 'conversion' do
    let(:fifty_euro) {Cash.new('EUR', 50)}

    before do
      Cash.conversion_rates('EUR', {
        'USD' => 1.11,
        'Bitcoin' => 0.0047
      })
    end

    it 'converts to a different currency' do
      expect(fifty_euro.convert_to('USD')).to be_a(Cash)
    end

    it 'fails with a wrong currency' do
      expect { fifty_euro.convert_to('Sausages') }.to raise_error(UnknownCurrencyError)
    end
  end
end
