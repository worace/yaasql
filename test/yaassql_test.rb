require 'test_helper'

class YaasqlTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Yaasql::VERSION
  end
end
