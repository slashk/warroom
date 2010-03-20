require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  test "is_pitcher? works for pitcher" do
    assert_equal(true, players(:players_114).is_pitcher?)
  end

  test "is_pitcher? fails for batter" do
    assert_equal(false, players(:players_001).is_pitcher?)
  end

  test "is_batter? works for batter" do
    assert_equal(true, players(:players_001).is_batter?)
  end

  test "is_batter? fails for pitcher" do
    assert_equal(false, players(:players_114).is_batter?)
  end

end
