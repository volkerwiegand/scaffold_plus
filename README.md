# ScaffoldPlus

A collection of little helpers for Rails scaffolding

## Installation

Add this line to your application's Gemfile:

    gem 'scaffold_plus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scaffold_plus

## Usage

### Add regular one-to-many association (has_many / belongs_to)
    rails generate scaffold_plus:has_many

This helper adds parent#has_many and child#belongs_to to the models
and updates the mass assignment whitelist in the controller.
It can also add a migration for the parent_id and a counter.

## Testing

Since I have no experience with test driven development (yet), this is
still an empty spot. Any help is highly appreciated.

## Contributing

1. Fork it ( https://github.com/volkerwiegand/scaffold_plus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
