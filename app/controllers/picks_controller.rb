class PicksController < ApplicationController

  def index
    @picks = Pick.picks_taken
  end

  def show
    @pick = Pick.find(params[:id])
  end

  def new
    @pick = Pick.new
  end

  def edit
    @pick = Pick.find(params[:id])
  end

  def create
    @pick = Pick.new(params[:pick])
    if @pick.save
      flash[:notice] = 'Pick was successfully created.'
      redirect_to(@pick)
    else
      render :action => "new"
    end
  end

  def update
    @pick = Pick.find(params[:id])

    if @pick.update_attributes(params[:pick])
      flash[:notice] = 'Pick was successfully updated.'
      redirect_to(@pick)
    else
      render :action => "edit"
    end
  end

  def destroy
    @pick = Pick.find(params[:id])
    @pick.destroy

    redirect_to(picks_url)
  end

  def scrolldraft
    @picks = Pick.picks_taken
    render :partial => "scrolldraft"
  end

  def scrollteam
    render :partial => "scrollteam"
  end

  def ticker
    @pick = Pick.picks_taken.first
    @next_pick = Pick.find(@pick.pick_number + 1)
    @team = @next_pick.user.team
    render :partial => "ticker"
  end

end
