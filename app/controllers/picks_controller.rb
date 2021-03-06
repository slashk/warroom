class PicksController < ApplicationController
  # before_filter :login_required, :except => [:current_pick]
  
  def index
    @picks = Pick.taken
  end

  def show
    @pick = Pick.find(params[:id])
  end

  def new
    @pick = Pick.new
  end

  def edit
    @pick = Pick.find(params[:id])
    @teams = User.all
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

  def current_pick
    current_pick = Pick.current.first
    respond_to do |wants|
      wants.js {
        unless current_pick.nil? 
          render :json => current_pick.to_json, :status => 200 
        else
          render :json => "", :status => 401   
        end         
            }
    end
  end

  def is_it_my_pick
    unless Pick.current.empty?
      res = Pick.current.first.user_id == current_user.id ? 1 : 0
    else
      res = 0
    end
    render :text => res #, :status => 200
  end

  def scrolldraft
    @picks = Pick.all(:conditions => "player_id IS NOT NULL", :order => "pick_number desc", :include => [:player, :user], :limit => 10)
    render :partial => "scrolldraft"
  end

  def scrollteam
    if draft_started? && !draft_over?
      current_pick = find_current_pick
      @upcoming = Pick.remaining(:limit => 10)
      @last_pick_time =  draft_started? ? find_last_pick_time : Time.now
      render :partial => "scrollteam"
    else
      render :text => ""
    end
  end

  def inline
    current_pick = Pick.current
    if current_pick.empty?
      render :text => "draft not currently running"
    else
      @upcoming = Pick.all(:conditions => "player_id IS NULL", :order => "pick_number asc", :include =>  :user, :limit => 5)
      @last_pick_time =  draft_started? ? find_last_pick_time : Time.now
      render :partial => "inline"
    end
  end

  def myteam
    # finds all picks even future ! need to compact otherwise you get NIL elements
    mypicks = Pick.find_all_by_user_id(current_user, :include => :player) 
    unless mypicks.nil?
      @myTeamCount = countPlayers(mypicks.map{|x| x.player}.compact)
    end
    render :partial => "myteam"
  end

  def ticker
    unless draft_over?
      @pick = Pick.taken.first
      @next_pick = find_current_pick
      @team = @next_pick.user.team
      render :partial => "ticker"
    else
      render :text => "Draft Finished!"
    end
  end
  
  def draft
    if !Pick.current.empty? && current_user.id == Pick.current.first.user_id
      @pick = Pick.current.first
      @pick.player_id = params[:player_id]
      
      if @pick.save
        render :text => "OK", :status => 200
      else
        render :text => "Bad", :status => 500
      end
    end
  end

end
