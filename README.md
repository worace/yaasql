# Yaasql

Basic SQL-templating library inspired by [https://github.com/krisajenkins/yesql](https://github.com/krisajenkins/yesql).

You can read more about the rationale for a library like this in [Yesql's Readme](https://github.com/krisajenkins/yesql#rationale)

## Usage

### Installing

```ruby
gem 'yaasql'
```

### Defining Queries

Create a `.sql` file to define your queries.

Queries **must** be identified with a comment line each query a name. This name will become the name of the Ruby method yaasql eventually creates for your query.

You may have multiple queries per file.

```sql
-- name: count_examples
SELECT COUNT(*) FROM examples;
```

### Loading queries

```ruby
require 'yaasql/db'
require 'pg'

class MyDB
  DB_CONN = PG.connect(DB_URL)
  extend Yaasql::DB
  define_queries("./queries.sql", DB_CONN)
end

MyDB.new.count_examples
# => [{"count" => "3"}]
```

### Parameterizing Queries

Words with a leading `:` in query files will be interpreted as arguments to the query.

```sql
-- name: get_example_by_id
SELECT * FROM examples where id = :id limit 1;

-- name: get_examples_by_id
SELECT * FROM examples where id =ANY(:ids);
```

Arguments can then be provided as a symbol-keyed hash when querying the function:

```ruby
db = MyDB.new

db.get_example_by_id({id: 1})
# => [{"id" => "1", "name" => "example 1"}]

db.get_examples_by_id({ids: [1,2,3]})
# => [{"id" => "1", "name" => "example 1"}, {"id" => "2", "name" => "example 2"}]
```

## Development

Requires a local postgres server for testing.

```bash
bundle install
rake setup # creates the test postgres DB
rake # runs tests
```

### Releasing

* Builds the `.gem` package
* Creates and pushes a git tag for the current version
* Pushes the `.gem` to [rubygems.org](https://rubygems.org)

```
bundle exec rake release
```

### Building a `.gem` package

```
bundle exec rake build
```

### Installing Dev Version Locally

```
bundle exec rake install
```

#### Feature Wishlist

* [X] Reading multiple queries from single string (blank-line separated?)
* [X] Module for including into a namespace
* [X] Metaprogramming for defining query methods
* [X] Define queries from a file
* [X] Support array queries with `=ANY()`
* [ ] `where IN (...)` queries
* [ ] Option for stdout / stdin redirection (to support `COPY FROM` / `COPY TO` queries)
* [ ] Option for streaming queries to process results row-by-row (e.g. for large datasets)
* [ ] Support positional `?` arguments

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

