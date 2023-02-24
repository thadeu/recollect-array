<p align="center">
  <h1 align="center">㌨ nano-collection-filter</h1>
  <p align="center"><i>Simple wrapper to filter array using Pure Ruby and conditions</i></p>
</p>

<p align="center">
  <a href="https://rubygems.org/gems/nano-collection-filter">
    <img alt="Gem" src="https://img.shields.io/gem/v/nano-collection-filter.svg?style=flat-square">
  </a>

  <a href="https://github.com/thadeu/nano-collection-filter/actions/workflows/ci.yml">
    <img alt="Build Status" src="https://github.com/thadeu/nano-collection-filter/actions/workflows/ci.yml/badge.svg">
  </a>
</p>


## Motivation

Because in sometimes, we need filter array passing conditions. This gem simplify this work.

## Documentation <!-- omit in toc -->

Version    | Documentation
---------- | -------------
unreleased | https://github.com/thadeu/nano-collection-filter/blob/main/README.md

## Table of Contents <!-- omit in toc -->
  - [Installation](#installation)
  - [Usage](#usage)
  - [Configuration](#configuration)
  - [Availables Predicates](#availables-predicates)

## Compatibility

| kind           | branch  | ruby               |
| -------------- | ------- | ------------------ |
| unreleased     | main    | >= 2.5.8, <= 3.1.x |

## Installation

Add this line to your application's Gemfile.

```ruby
gem 'nano-collection-filter', '~> 0.0.1'
```

## Configuration

Without configuration, because we use only Ruby. ❤️

## Availables Predicates

| Type | suffix |
| ----------- | ----------- |
| Equal | eq      |
| NotEqual | noteq        |
| Contains | cont        |
| NotContains | notcont        |
| Included | in        |
| NotIncluded | notin        |
| Start | start        |
| NotStart | notstart        |
| End | end        |
| NotEnd | notend        |
| LessThan | lt        |
| LessThanEqual | lteq        |
| GreaterThan | gt        |
| GreaterThanEqual | gteq        |


## Usage

<details>
  <summary>Data</summary>
  
  ```ruby
  data = [
    {
      id: 1,
      name: 'Test #1',
      email: 'test1@email1.com',
      schedule: { all_day: true },
      numbers: %w[1 2],
      active: true,
      count: 9
    },
    {
      id: 2,
      name: 'Test #2',
      email: 'test2@email2.com',
      schedule: { all_day: false },
      numbers: %w[3 4],
      active: true,
      count: 10
    },
    {
      id: 3,
      name: 'Test #3',
      email: 'test3@email3.com',
      schedule: { all_day: false },
      numbers: %w[5 6],
      active: false,
      count: 99
    }
  ]
  ```
</details>


## Equal

```ruby
filters = { active_eq: true }

collection = Nano::Collection::Search.apply(data, filters)
```

## NotEqual

```ruby
filters = { active_noteq: true }

collection = Nano::Collection::Search.apply(data, filters)
```

## Nested Hash Paths

```ruby
filters = { 'schedule.all_day_eq': false }

collection = Nano::Collection::Search.apply(data, filters)
```

## Nested Array Paths

> Note the `.0` 🎉

```ruby
filters = { 'numbers.0_eq': '3' }

collection = Nano::Collection::Search.apply(data, filters)
```

```ruby
filters = { numbers_in: ['1'] }

collection = Nano::Collection::Search.apply(data, filters)

expect(collection.result.size).to eq(1)
```

## Combine conditions

```ruby
filters = {
  active_noteq: true,
  numbers_in: %w[5],
  email_cont: 'test3',
  'schedule.all_day': false
}

collection = Nano::Collection::Search.apply(data, filters)
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thadeu/nano-collection-filter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/thadeu/nano-collection-filter/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

We have a long list of valued contributors. Check them all at: https://github.com/thadeu/nano-collection-filter.
