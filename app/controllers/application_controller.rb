class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # this is for restful authentication
  include AuthenticatedSystem

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '777b0c67942ff980eb19a6d597a92b2c'
  
  def draft_started?
    Pick.count > 0 && Pick.taken.size > 0
  end

  def draft_over?
    Pick.taken.count >= Pick.count
  end
  
  def find_current_pick
    # if this is the last pick of the draft, return the last pick of the draft
    if Pick.taken.count < Pick.count
      return Pick.find_by_pick_number(Pick.taken.count + 1)
    else
      return Pick.find_by_pick_number(Pick.taken.count)
    end
  end

  # find the team who is currently on the clock
  def find_user_on_clock
    return Pick.find_by_pick_number(Pick.taken.count + 1).user
  end

  # find the time of the last pick
  def find_last_pick_time
    if draft_started? && !draft_over?
      Pick.find_by_pick_number(Pick.taken.count).updated_at
    end
  end

  # return an array of player_id that is the users watchlist
  def compile_watchlist(user)
    w = Watchlist.find_all_by_user_id(user)
    return w.map {|x| x.player_id }
  end

  # take player object array and return hash of Y! position with count in each
  def countPlayers(players)
    temp_array = players.map {|x| x.pos.split(" ")}
    temp_array.flatten!
    posCount = Hash.new(0) 
    temp_array.each {|x| posCount[x]+=1 } 
    temp_array.each {|x| posCount['P']+=1 if x.include? "P"}
    posCount['Total'] = players.size
    return posCount
  end
  
  def countPitchers(players)
    @retainees.map {|x| x.id if x.is_pitcher?}.compact.count
  end

  def countBatters(player)
    @retainees.map {|x| x.id if x.is_batter?}.compact.count    
  end

  def is_admin?(user)
      logged_in? && User.find(user).role == "admin"
  end

  def am_i_admin?
    logged_in? && User.find(current_user).role == "admin"
  end

  def admin_role_required
    unless am_i_admin?
      flash[:error] = "Admin login required. Please login as admin."
       redirect_to :controller => '/session', :action => 'new'
     end
  end

end
