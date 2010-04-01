require 'test_helper'

class WatchlistTest < ActiveSupport::TestCase

  test "should mine named_scope work" do
    assert_equal(1, Watchlist.mine(users(:commish).id).count)
  end

  test "should mine named_scope work even when nil" do
    # ron has no watchlist
    assert_equal(0, Watchlist.mine(users(:ron).id).count)
  end
  
  test "should mine named_scope increase when adding players" do
    assert_difference "Watchlist.mine(users(:commish).id).count", 1 do
      Watchlist.create(:user_id => users(:commish).id, :player_id => Player.undrafted.first.id)
    end
  end

end
