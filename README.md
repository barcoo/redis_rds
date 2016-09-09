# RedisRds

[![GitHub release](https://img.shields.io/badge/release-0.1.4-blue.png)](https://github.com/barcoo/redis_rds/releases/tag/0.1.4)
[![Build Status](https://travis-ci.org/barcoo/redis_rds.svg?branch=master)](https://travis-ci.org/barcoo/redis_rds)
[![Coverage Status](https://coveralls.io/repos/github/barcoo/redis_rds/badge.svg?branch=master&update=now)](https://coveralls.io/github/barcoo/redis_rds?branch=master)

Ruby data structures stored in Redis.

RedisRds provides Redis-backed Ruby interfaces for the following data structures:

* String
* Hash
* ExpirableHash
* NestedHash
* List
* Mutex
* Set
* SortedSet
* SortedStringSet

## Installation

Add to your gemfile:

```ruby
gem 'redis_rds', git: 'git@github.com:barcoo/redis_rds.git'
```

## Usage

Best is to check [the tests](test/) to see how to use the data structures.
Here is one example, for String:

```ruby
# configure RedisRds by passing either a connection
RedisRds.configure(connection: my_redis_connection, namespace: 'my_app')
# or connection parameters
RedisRds.configure(
  host: 'localhost',
  db: 1,
  port: 6379,
  namespace: 'my_app',
)
```

```ruby
string_a = RedisRds::String.new('some_key')
string_a = 'hello'

string_b = RedisRds::String.new('some_key')
puts string_b
# 'hello'
```

## Contributing

Take a look at the [Roadmap](doc/ROADMAP.md) and lint your code using [rubocop](https://github.com/bbatsov/rubocop) and our [rubocop.yml](.rubocop.yml) file.

To run the tests, start a Redis server on localhost and run `bundle exec rake test`.

To contribute:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Release

___Note___: eventually use one of the popular git release scripts to tag, create tag notes, etc., based on git changelog.

When you want to create a new release, use the rake task ```cim:release``` (in the main Rakefile)

```shell
bundle exec rake cim:release
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
