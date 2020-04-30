![MacAddresses Logo](/assets/logo_no_bg.png)

<!-- # [![Build Status](https://travis-ci.org/space-bunny/ruby_sdk.svg)](https://travis-ci.org/space-bunny/ruby_sdk)
[![Gem Version](https://badge.fury.io/rb/spacebunny.svg)](https://badge.fury.io/rb/spacebunny) -->

This Gem has been created with the intention of making it simple to determine MAC addresses.
Heavily inspired by [macaddr](https://github.com/ahoward/macaddr)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mac_addresses'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mac_addresses

## Usage

First you have to fetch MAC addresses:

```ruby
MacAddresses.fetch  # this also returns the list of addresses
```

Then you can access the cached addresses with:

```ruby
MacAddresses.list
```

### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/FancyPixel/mac_addresses.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](contributor-covenant.org) code of conduct.

### Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
