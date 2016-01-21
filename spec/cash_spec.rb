require 'spec_helper'

describe Cash do
  it 'has a version number' do
    expect(Cash::VERSION).not_to be nil
  end

  describe 'configuration' do
    it 'can instantiate without setup' do
      expect(Cash.new('EUR', 50)).not_to raise_error
    end

    it 'fails on convertion without rates' do
      expect(Cash.new('EUR', 50).convert_to('USD')).to raise_error
    end
  end

  describe 'convertion' do
    let(:fifty_euro) {Cash.new('EUR', 50)}

    before do
      Cash.convertion_rates('EUR', {
        'USD' => 1.11,
        'Bitcoin' => 0.0047
      })
    end

    it 'converts to a different currency' do
      expect(fifty_euro.convert_to('USD')).to be_a Cash
    end

    it 'fails with a wrong currency' do
      expect(fifty_euro.convert_to('Sausages')).to raise_error
    end
  end
end
