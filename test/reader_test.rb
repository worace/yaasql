
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

  def setup
    @r = Yaassql::Reader.new
  end

  def test_reading_query_name
    assert_equal :count_examples, r.query_name(sample_query)
  end

  def test_errors_with_no_name
    assert_raises ArgumentError do
      r.query_name("pizza")
    end
  end
end
