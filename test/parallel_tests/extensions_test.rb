require 'test_helper'

class ParallelTests::ExtensionsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ParallelTests::Extensions::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
