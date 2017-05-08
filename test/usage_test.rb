require 'test_helper'
require 'pg'
require 'yaasql/db'

DB_URL = "postgres://localhost/yaasql_test"
DB = PG.connect(DB_URL)

class MyDB
  extend Yaasql::DB
  define_queries("./test/queries.sql", DB)
end

class UsageTest < Minitest::Test
  attr_reader :db
  def setup
    @db = MyDB.new
  end

  def test_defines_query_methods
    assert db.respond_to?(:count_examples)
    assert db.respond_to?(:get_example_by_id)
    assert db.respond_to?(:get_examples_by_id)
  end

  def test_executing_queries
    assert_equal [{"count" => "3"}], db.count_examples
    assert_equal [{"id" => "1", "name" => "example 1"}], db.get_example_by_id({id: 1})
    assert_equal [{"id" => "1", "name" => "example 1"},
                  {"id" => "2", "name" => "example 2"}], db.get_examples_by_id({ids: [1,2]})
  end
end
