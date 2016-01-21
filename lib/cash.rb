class UnknownCurrencyError < StandardError; end
class ExchangeRateZeroError < StandardError; end

class Cash
  @_base_currency = nil
  @_conversion_rates = {}

  def self.conversion_rates(base, rates)
    raise ExchangeRateZeroError if rates.values.include? 0
    @_base_currency = String(base)
    @_conversion_rates = Hash(rates)
  end

  def self.currencies
    [@_base_currency, @_conversion_rates.keys].flatten
  end

  def self.get_base
    @_base_currency
  end

  def self.get_rates
    @_conversion_rates
  end

  def initialize(currency, amount)
    raise UnknownCurrencyError unless Cash.currencies.include?(currency)

    @currency = currency
    @amount = amount
  end

  def convert_to(currency)
    return Cash.new(currency, amount_in(currency))
  end

  private

  def amount_in(currency)
    raise UnknownCurrencyError unless Cash.currencies.include?(currency)
    exchange_rate = Cash.get_rates[currency]
    base_value * exchange_rate
  end

  def base_value
    if Cash.get_base == @currency
      @amount
    else
      own_rate = Cash.currencies[@currency]
      amount / own_rate
    end
  end
end
