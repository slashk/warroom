class PicksController < ApplicationController
  before_filter :login_required

  def index
    @picks = Pick.picks_taken
    current_pick = find_current_pick
    @upcoming = Pick.find(:all, :conditions => "pick_number >= #{current_pick.pick_number}",
      :order => "pick_number asc", :limit => 10, :include => :user )
    @last_pick_time = find_last_pick_time
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
    current_pick = find_current_pick
    @upcoming = Pick.find(:all, :conditions => "pick_number >= #{current_pick.pick_number}",
      :order => "pick_number asc", :limit => 10, :include => :user )
    @last_pick_time =  draft_started? ? find_last_pick_time : Time.now
    render :partial => "scrollteam"
  end

  def inline
    current_pick = find_current_pick
    @upcoming = Pick.find(:all, :conditions => "pick_number >= #{current_pick.pick_number}",
      :order => "pick_number asc", :limit => 10, :include => :user )
    @last_pick_time =  draft_started? ? find_last_pick_time : Time.now
    render :partial => "inline"
  end

  def myteam
    mypicks = Pick.find_all_by_user_id(current_user.id, :include => :player)
    myTeamCount = countPlayers(mypicks)
    @SS = myTeamCount['SS']
    @B1 = myTeamCount['1B']
    @B2 = myTeamCount['2B']
    @B3 = myTeamCount['3B']
    @OF = myTeamCount['OF']
    @SP = myTeamCount['SP']
    @RP = myTeamCount['RP']
    @C = myTeamCount['C']
    render :partial => "myteam"
  end

  def ticker
    unless draft_over?
      @pick = Pick.picks_taken.first
      @next_pick = find_current_pick
      @team = @next_pick.user.team
      render :partial => "ticker"
    else
      render :text => "Draft Finished!"
    end
  end

end
