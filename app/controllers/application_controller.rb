class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # this is for restful authentication
  include AuthenticatedSystem

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '777b0c67942ff980eb19a6d597a92b2c'
  
  def draft_started?
    Pick.picks_taken.size > 0
  end

  def draft_over?
    Pick.picks_taken.count >= Pick.count
  end

  def find_current_pick
    # if this is the last pick of the draft, return the last pick of the draft
    if Pick.picks_taken.count < Pick.count
      return Pick.find_by_pick_number(Pick.picks_taken.count + 1)
    else
      return Pick.find_by_pick_number(Pick.picks_taken.count)
    end
  end

  # find the team who is currently on the clock
  def find_user_on_clock
    return Pick.find_by_pick_number(Pick.picks_taken.count + 1).user
  end

  # find the time of the last pick
  def find_last_pick_time
    if Pick.picks_taken.count > 0
      Pick.find_by_pick_number(Pick.picks_taken.count).updated_at
    end
  end

  # return an array of player_id that is the users watchlist
  def compile_watchlist(user)
    w = Watchlist.find_all_by_user_id(user)
    return w.map {|x| x.player_id }
  end

  # take player object array and return hash of Y! position with count in each
  def countPlayers(players)
    posCount = Hash.new
    ypos = %w(SP RP 1B 2B 3B SS C OF P)
    ypos.each do |z|
      posCount[z] = 0
    end
    players.each do |x|
      ypos.each do |pos|
        posCount[pos] += 1 if x.player.pos.include?(pos)
      end
    end
    return posCount
  end

end
