require 'test_helper'

class PickTest < ActiveSupport::TestCase

  # this set all assumes that draft is fully over (via fixtures)
  test "should get number of taken" do
    assert_equal(Pick.count, Pick.taken.count)
  end

  test "should get number of taken with limit" do
    assert_equal(10, Pick.all(:conditions => "player_id IS NOT NULL", :order => "pick_number asc", :include =>  :user, :limit => 10).size)
  end

  test "should get number remaining" do
    assert_equal(0, Pick.remaining.count)    
  end

  test "should get number remaining when not zero" do
    assert_difference "Pick.remaining.count", 15 do
      y = Pick.all(:limit => 15)
      y.each do |x|
        x.player_id = nil
        x.save
      end
    end
    x = Pick.all(:conditions => "player_id IS NULL", 
    :order => "pick_number asc", 
    :include =>  :user, 
    :limit => 10)
    assert_equal(10, x.size)
  end

  test "should return curent pick" do
    # this returns zero because draft is over
    assert_equal(0, Pick.current.count)
  end
  
end
