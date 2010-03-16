class WatchlistController < ApplicationController

  def index
  end
  
  def new
  end
  
  def show
    # current_user = User.find_by_remember_token(params[:id])
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
