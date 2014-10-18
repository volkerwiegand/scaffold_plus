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

### Add a collection to a resource route
    rails generate scaffold_plus:collection

This helper works on config/routes.rb and adds code for a collection
to a newly created resource route.

### Add ancestry to create a tree structure (or hierarchy)
    rails generate scaffold_plus:ancestry

This helper adds has_ancestry to the model and updates the mass assignment
whitelist in the controller. It can also add a migration.

### Add many-to-many association with intermediate join table
    rails generate scaffold_plus:many_to_many

This helper creates a join table and updates the two parent resources.
It can handle additional attributes in the join table incl. whitelisting
and accepts_nested_attributes_for in one of the parents.

### Add many-to-many association with has_and_belongs_to_many
    rails generate scaffold_plus:habtm

This helper scaffolds a has_and_belongs_to_many relationship with migration
and updates to the models.

### Set the autofocus flag on a column
    rails generate scaffold_plus:autofocus

This helper adds "autofocus: true" to an input field in the form view.

### Add geo location to resource
    rails generate scaffold_plus:geocoder_init
    rails generate scaffold_plus:geocoder

These helpers need the [geocoder](http://www.rubygeocoder.com) gem.

The first helper creates an initializer for geocoder. It supports the
language (default 'de'), timeout (default 5) and units (default km)
options.

The second one adds geolocating to a resource. It uses Google geocoding
and requires 'lat', 'lng' and 'address' attributes (the names can be
changed via options). If a '--country' flag is added, the helper
tries to isolate the country from the address and stores the country
code (e.g. DE or NL) in a given 'country' attribute. This is currently
only implemented for Germany (DE).

## Testing

Since I have no experience with test driven development (yet), this is
still an empty spot. Any help is highly appreciated.

## Contributing

1. Fork it ( https://github.com/volkerwiegand/scaffold_plus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
