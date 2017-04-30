require 'test_helper'
require 'yaassql/query'
require 'pg'

class YaassqlTest < Minitest::Test
  def sample
    <<~QUERY
      -- name: count_examples
      SELECT COUNT(*) FROM examples;
    QUERY
  end

  def test_getting_a_query
    query = Yaassql::Query.from_string(sample)
    assert_equal :count_examples, query.name
    assert_equal "SELECT COUNT(*) FROM examples;", query.body
    assert_equal [], query.arguments
  end

  def test_executing_query
    url = "postgres://localhost/yaassql_test"
    conn = PG.connect(url)
    q = Yaassql::Query.from_string(sample)
    assert_equal [{"count" => "3"}], q.execute(conn)
  end
end
