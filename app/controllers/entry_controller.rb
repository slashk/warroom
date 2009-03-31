class EntryController < ApplicationController

  def index
    @pick = find_current_pick
    @teams = User.all
  end

  def create
    @pick = Pick.new(params[:pick])
    @pick.save ? flash[:notice] = 'Player was successfully created.' :  flash[:error] = 'Error in saving your pick'
    redirect_to :action => 'new'
  end

  def update
    @pick = Pick.find(params[:id])

    if @pick.update_attributes(params[:pick])
      flash[:notice] = 'Player was successfully drafted.'
    else
      flash[:error] = "Player not drafted"
    end
    render :controller => index
  end

end
