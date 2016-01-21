class UnknownCurrencyError < StandardError; end
class ExchangeRateZeroError < StandardError; end

class Cash
  @_base_currency = nil
  @_conversion_rates = {}

  # Setup conversion rates, relative to base currency.
  # Must be done before instantiating Cash objects.
  #
  # @example
  #   Cash.conversion_rates('USD', {'DKK' => '0.23'})
  #
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

  def real_amount
    @amount
  end

  def convert_to(currency)
    return Cash.new(currency, amount_in(currency))
  end

  # Printing

  def amount
    '%.2f' % @amount
  end

  def currency
    @currency
  end

  def inspect
    "#{currency} #{amount}"
  end

  # Arithmetics

  def +(money)
    raise ArgumentError unless money.is_a?(Cash)
    Cash.new(@currency, money.convert_to(@currency).real_amount + @amount)
  end

  def -(money)
    raise ArgumentError unless money.is_a?(Cash)
    Cash.new(@currency, @amount - money.convert_to(@currency).real_amount)
  end

  def /(number)
    raise ZeroDivisionError if number == 0
    Cash.new(@currency, @amount / number)
  end

  def *(number)
    Cash.new(@currency, @amount * number)
  end

  # Comparison

  def ==(money)
    raise ArgumentError unless money.is_a?(Cash)
    real_amount.round(2) == money.convert_to(@currency).real_amount.round(2)
  end

  def >(money)
    raise ArgumentError unless money.is_a?(Cash)
    real_amount > money.convert_to(@currency).real_amount
  end

  def <(money)
    raise ArgumentError unless money.is_a?(Cash)
    real_amount < money.convert_to(@currency).real_amount
  end

  private

  def amount_in(currency)
    raise UnknownCurrencyError unless Cash.currencies.include?(currency)
    exchange_rate = Cash.get_rates[currency] || 1
    base_value * exchange_rate
  end

  def base_value
    if Cash.get_base == @currency
      @amount
    else
      own_rate = Cash.get_rates[@currency]
      @amount / own_rate
    end
  end
end
