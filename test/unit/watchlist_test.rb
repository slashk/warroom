require 'test_helper'

class WatchlistTest < ActiveSupport::TestCase

  test "should mine named_scope work" do
    assert_equal(1, Watchlist.mine(users(:commish).id).count)
  end

  test "should mine named_scope work even when nil" do
    # ron has no watchlist
    assert_equal(0, Watchlist.mine(users(:ron).id).count)
  end

end
