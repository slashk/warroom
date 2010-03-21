require 'test_helper'

class PickTest < ActiveSupport::TestCase

  # this set all assumes that draft is fully over (via fixtures)
  test "should get number of taken" do
    assert_equal(Pick.count, Pick.taken.count)
  end

  test "should get number remaining" do
    assert_equal(0, Pick.remaining.count)    
  end

  test "should return curent pick" do
    # this returns zero because draft is over
    assert_equal(0, Pick.current.count)
  end

end
