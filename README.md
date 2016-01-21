# Cash

Simple gem to deal with currencies. Made as challenge, please don't use for anything that matters.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cash', github: 'kholbekj/cash'
```

And then execute:

    $ bundle

## Usage

### Set it up
```ruby
Cash.convertion_rates('EUR', { 'USD' => '1.11', 'DKK' => '0.15'})
```

### Then play with the cash!
```ruby
fifty_bucks = Cash.new('USD', 50)
fifty_bucks_in_euro = fifty_bucks.convert_to('EUR')

fifty_bucks == fifty_bucks_in_euro
#=> true
```


## Contributing

1. Fork it ( https://github.com/kholbekj/cash/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
6. Pull yourself together and contribute to a serious gem
