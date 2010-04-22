class PlayersController < ApplicationController
  before_filter :login_required

  def index
    @players = Player.undrafted.byrank.limited
    cookies[:team] = current_user.id.to_i # set this cookie for js 
    unless @players.empty?
      playerslist = @players.map {|x| x.id}
      @teams = User.draftorder
      @watched = Watchlist.find_all_by_user_id(current_user, :conditions => ["player_id in (?)", playerslist])
      @watchlist = compile_watchlist(current_user)
    else
      redirect_to :controller => "admin"
    end
  end

  def show
    begin
      @player = Player.find(params[:id])
    rescue
      @player = Player.new(:player => "not found", :yahoo_ref => "9999")
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
      format.js { render :text => "#{@player.player}", :layout => false}
    end
  end

  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        flash[:notice] = 'Player was successfully created.'
        format.html { redirect_to(@player) }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        flash[:notice] = 'Player was successfully updated.'
        format.html { redirect_to(@player) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end

  def searchbyname
    @players = Player.undrafted.byname(params[:searchtext])
    @watchlist = compile_watchlist
    render :partial => "search"
  end

  def searchbyfranchise
    picks = Pick.find_all_by_user_id(params[:team], :include => :player)
    @players = picks.map {|x| x.player }
    @players.compact!
    @watchlist = compile_watchlist(current_user)
    render :partial => "search"
  end

  def searchbyteam
    @players = Player.undrafted.find_all_by_team(params[:team])
    @watchlist = compile_watchlist(current_user)
    render :partial => "search"
  end

  def searchbypos
    @watchlist = compile_watchlist(current_user)
    case params[:fieldPosition]
    when "BATTERS"
      @players = Player.undrafted.batters
    when "PITCHERS"
      @players = Player.undrafted.pitchers
    when "ALL"
      @players = Player.undrafted(:order => "orank asc")
    when "Top"
      @players = Player.undrafted.byrank.limited
    else
      @players = Player.undrafted.bypos(params[:fieldPosition])
    end
    render :partial => "search"
  end

  def searchbywatchlist
    # find your watchlist [player.id], find drafted_players, find players in w but not in dp
    @watchlist = compile_watchlist(current_user)
    drafted_players = Pick.all(:select => "player_id").map {|x| x.player_id}
    @players = Player.all(:conditions => ['id in (?)', @watchlist - drafted_players])
    render :partial => "search"
  end

  def confirm_draftee
    @player = Player.find(params[:id])
    render :layout => false
  end

  def add_to_watchlist
    # check to make sure he doesn't already exist
    unless Watchlist.find_by_player_id_and_user_id(params[:id], current_user.id)
      @subject = Watchlist.new(:player_id => params[:id], :user_id => current_user.id)
      if @subject.save
        status = 200
      else
        status = 401
      end
    else
      status = 401
    end
    render :nothing => true, :status => status
  end

  def remove_from_watchlist
    @subject = Watchlist.find_by_player_id(params[:id])
    @subject.destroy
    render :nothing => true
  end

end
