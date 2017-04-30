require 'test_helper'
require "yaassql/reader"

class ReaderTest < Minitest::Test
  attr_reader :r
  def sample_query
    <<~QUERY
      -- name: count_examples
      SELECT COUNT(*) FROM examples;
    QUERY
  end

  def sample_with_whitespace
    <<~QUERY
      -- name: count_examples
        -- Additional comment....
      SELECT COUNT(*) FROM examples;
    QUERY
  end

  def sample_with_args
    <<~QUERY
      -- name: count_examples
      SELECT COUNT(*) FROM examples where id = :id and name = :name;
    QUERY
  end

  def setup
    @r = Yaassql::Reader.new
  end

  def test_reading_query_name
    assert_equal :count_examples, r.name(sample_query)
  end

  def test_errors_with_no_name
    assert_raises ArgumentError do
      r.name("pizza")
    end
  end

  def test_reading_raw_body
    assert_equal "SELECT COUNT(*) FROM examples;", r.raw_body(sample_query)
    assert_equal "SELECT COUNT(*) FROM examples;", r.raw_body(sample_with_whitespace)
  end

  def test_prepping_body_with_sql_args
    with_args = "SELECT COUNT(*) FROM examples where id = $1 and name = $2;"
    components = r.components(sample_with_args)
    assert_equal with_args, components[:body]
  end

  def test_reading_named_arguments
    assert_equal([:id, :name], r.arguments("where id = :id and name = :name"))
    assert_equal([:id, :name], r.arguments("where id = :id and name = :name;"))
    assert_equal([:id], r.arguments("where id=:id;"))
    assert_equal([], r.arguments("select * from examples;"))
  end

  def test_reading_queries_from_file
    queries = r.from_file("./test/queries.sql")
    assert_equal 3, queries.count
    assert_equal [:count_examples, :get_example_by_id, :get_examples_by_id], queries.map(&:name)
    assert_equal [[], [:id], [:ids]], queries.map(&:arguments)
  end
end
