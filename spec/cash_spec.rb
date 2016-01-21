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
    let(:fifty_euro) { Cash.new('EUR', 50) }

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

  describe 'arithmetics' do
    let(:thirty_euro) { Cash.new('EUR', 30) }
    let(:fifteen_dollars) { Cash.new('USD', 15) }

    before do
      Cash.conversion_rates('EUR', {
        'USD' => 1.11,
        'Bitcoin' => 0.0047
      })
    end

    describe '#+' do
      it 'adds two values of same currency' do
        result = thirty_euro + thirty_euro
        expect(result).to be_a(Cash)
        expect(result.currency).to eq('EUR')
        expect(result.amount).to eq('60.00')
      end

      it 'adds two different currencies' do
        result = thirty_euro + fifteen_dollars
        expect(result).to be_a(Cash)
        expect(result.currency).to eq('EUR')
        expect(result.amount).to eq('43.51')
      end

      it 'fails with wrong argument' do
        expect { thirty_euro + 2 }.to raise_error(ArgumentError)
      end
    end

    describe '#-' do
      it 'subtracts two values of same currency' do
        result = thirty_euro - thirty_euro
        expect(result).to be_a(Cash)
        expect(result.currency).to eq('EUR')
        expect(result.amount).to eq('0.00')
      end

      it 'subtracts two different currencies' do
        result = thirty_euro - fifteen_dollars
        expect(result).to be_a(Cash)
        expect(result.currency).to eq('EUR')
        expect(result.amount).to eq('16.49')
      end

      it 'fails with wrong argument' do
        expect { thirty_euro - 2 }.to raise_error(ArgumentError)
      end
    end

    describe '#*' do
      it 'multiplies amount by value' do
        result = thirty_euro * 2
        expect(result).to be_a(Cash)
        expect(result.currency).to eq('EUR')
        expect(result.amount).to eq('60.00')
      end
    end

    describe '#/' do
      it 'divides amount by value' do
        result = thirty_euro / 2
        expect(result).to be_a(Cash)
        expect(result.currency).to eq('EUR')
        expect(result.amount).to eq('15.00')
      end

      it 'fails if argument is 0' do
        expect { thirty_euro / 0 }.to raise_error(ZeroDivisionError)
      end
    end
  end

  describe "comparisons" do
    let(:six_dollars) { Cash.new('USD', 6) }
    let(:seven_dollars) { Cash.new('USD', 7) }
    let(:six_dollars_in_euro) { Cash.new('EUR', 5.4054) }
    let(:seven_euro) { Cash.new('EUR', 7) }

    before do
      Cash.conversion_rates('EUR', {
        'USD' => 1.11,
        'Bitcoin' => 0.0047
      })
    end

    describe "#==" do
      it 'compares same currency' do
        expect(six_dollars == six_dollars).to eq(true)
        expect(six_dollars == seven_dollars).to eq(false)
      end

      it 'compares different currencies' do
        expect(six_dollars == six_dollars_in_euro).to eq(true)
        expect(six_dollars == seven_euro).to eq(false)
      end
    end

    describe "#>" do
      it 'compares same currency' do
        expect(seven_dollars > six_dollars).to eq(true)
        expect(six_dollars > seven_dollars).to eq(false)
      end

      it 'compares different currencies' do
        expect(seven_euro > seven_dollars).to eq(true)
        expect(six_dollars_in_euro > seven_dollars).to eq(false)
      end
    end

    describe "#<" do
      it 'compares same currency' do
        expect(seven_dollars < six_dollars).to eq(false)
        expect(six_dollars < seven_dollars).to eq(true)
      end

      it 'compares different currencies' do
        expect(seven_euro < seven_dollars).to eq(false)
        expect(six_dollars_in_euro < seven_dollars).to eq(true)
      end
    end
  end

  describe 'representing values' do
    let(:five_dollars) { Cash.new('USD', 5) }

    before do
      Cash.conversion_rates('EUR', {
        'USD' => 1.11,
        'Bitcoin' => 0.0047
      })
    end

    it "inspects" do
      expect(five_dollars.inspect).to eq('USD 5.00')
    end

    it "formats amount" do
      expect(five_dollars.amount).to eq('5.00')
    end

    it "tells currency" do
      expect(five_dollars.currency).to eq('USD')
    end
  end
end
