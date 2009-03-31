class EntryController < ApplicationController

  def new
    @pick = find_current_pick
    @teams = User.all
    render 
  end

  def create
    @pick = Pick.new(params[:pick])
    @pick.save ? flash[:notice] = 'Player was successfully created.' :  flash[:error] = 'Error in saving your pick'
    redirect_to :action => 'new'
  end

end
