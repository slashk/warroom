require 'test_helper'

class RetaineeTest < ActiveSupport::TestCase

  test "should mine named_scope work" do
    # commish has six retainees
    assert_equal(6, Retainee.mine(users(:commish).id).count)
  end

end
