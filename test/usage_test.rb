require 'test_helper'
require 'pg'
require 'yaassql/db'

DB_URL = "postgres://localhost/yaassql_test"
DB = PG.connect(DB_URL)

class MyDB
  extend Yaassql::DB
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
end
