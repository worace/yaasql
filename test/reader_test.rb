
require 'test_helper'
require "yaassql/reader"

class YaassqlTest < Minitest::Test
  attr_reader :r
  def sample_query
    <<~QUERY
      -- name: count_examples
      -- Find the users with the given ID(s).
      SELECT COUNT(*) FROM examples;
    QUERY
  end

  def sample_with_whitespace
    <<~QUERY
      -- name: count_examples
        -- Find the users with the given ID(s).
      SELECT COUNT(*) FROM examples;
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

  def test_reading_body
    assert_equal "SELECT COUNT(*) FROM examples;", r.body(sample_query)
    assert_equal "SELECT COUNT(*) FROM examples;", r.body(sample_with_whitespace)
  end

  def test_reading_named_arguments
    assert_equal([:id, :name], r.arguments("where id = :id and name = :name"))
    assert_equal([:id, :name], r.arguments("where id = :id and name = :name;"))
    assert_equal([:id], r.arguments("where id=:id;"))
  end
end
