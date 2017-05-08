require 'test_helper'
require 'yaasql/query'
require 'pg'

class YaasqlTest < Minitest::Test
  def sample
    <<~QUERY
      -- name: count_examples
      SELECT COUNT(*) FROM examples;
    QUERY
  end

  def test_getting_a_query
    query = Yaasql::Query.from_string(sample)
    assert_equal :count_examples, query.name
    assert_equal "SELECT COUNT(*) FROM examples;", query.body
    assert_equal [], query.arguments
  end

  def test_executing_query
    url = "postgres://localhost/yaasql_test"
    conn = PG.connect(url)
    q = Yaasql::Query.from_string(sample)
    assert_equal [{"count" => "3"}], q.execute(conn)
  end
end
