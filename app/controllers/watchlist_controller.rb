class WatchlistController < ApplicationController
  # before_filter :login_required

  def index
  end
  
  def new
  end
  
  def show
    players = Player.undrafted.byrank
    unless players.nil?
      playerslist = players.map {|x| x.id}
      @watchlist = Watchlist.find_all_by_user_id(current_user, :conditions => ["player_id in (?)", playerslist])
      render :partial => "watchlist", :collection => @watchlist 
    end
  end
  
  def edit
  end
  
  def create
  end
  
  def destroy
  end

end
