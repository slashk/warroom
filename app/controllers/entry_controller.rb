class EntryController < ApplicationController
    before_filter :login_required


  def index
    @pick = find_current_pick
    @teams = User.all
  end

  def create
    @pick = Pick.new(params[:pick_number])
    @pick.save ? flash[:notice] = 'Player was successfully created.' :  flash[:error] = 'Error in saving your pick'
    redirect_to :action => 'index'
  end

  def update
    @pick = Pick.find_by_pick_number(params[:pick][:pick_number])

    if @pick.update_attributes(params[:pick])
      flash[:notice] = 'Player was successfully drafted.'
    else
      flash[:error] = "Player not drafted"
    end
    redirect_to :action => 'index'
  end

end
