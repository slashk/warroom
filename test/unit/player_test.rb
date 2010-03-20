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

  test "makes sure :undrafted named_scope returns only undrafted players" do
    assert_equal(89, Player.undrafted.count)
  end

  test "makes sure :batters named_scope returns only batters" do
    players = Player.batters
    players.each do |p|
      assert_equal(true, p.is_batter?)
    end    
  end

  test "makes sure :pitchers named_scope returns only pitchers" do
    players = Player.pitchers
    players.each do |p|
      assert_equal(true, p.is_pitcher?)
    end
  end

end
