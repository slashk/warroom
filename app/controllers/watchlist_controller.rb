class WatchlistController < ApplicationController
  # before_filter :login_required

  def index
  end
  
  def new
  end
  
  def show
    @watchlist = Watchlist.mine(current_user.id)
    render :partial => "watchlist", :collection => @watchlist
  end
  
  def edit
  end
  
  def create
    @subject = Watchlist.new(:player_id => params[:id], :user_id => current_user.id)
    @subject.save
  end
  
  def destroy
    @subject = Watchlist.find_by_player_id(params[:id])
    @subject.destroy
  end

end
