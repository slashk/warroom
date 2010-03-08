class PlayersController < ApplicationController
  before_filter :login_required

  def index
    @players = Player.undrafted.byrank
    unless @players.nil?
      playerslist = @players.map {|x| x.id}
      @teams = User.draftorder
      @watched = Watchlist.find_all_by_user_id(current_user, :conditions => ["player_id in (?)", playerslist])
      @watchlist = compile_watchlist(current_user)
      # draft results
      @picks = Pick.picks_taken_limited(15)
      # Pick order
      current_pick = find_current_pick
      @upcoming = Pick.find(:all, :conditions => "pick_number >= #{current_pick.pick_number}",
        :order => "pick_number asc", :limit => 10, :include => :user )
      @last_pick_time =  draft_started? ? find_last_pick_time : Time.now
      # my team
      mypicks = Pick.find_all_by_user_id(current_user.id, :include => :player)
      @myTeamCount = countPlayers(mypicks)
    else
      redirect_to :controller => "admin"
    end
  end

  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
      format.js { render :text => "#{@player.player}"}
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
    @players = Player.undrafted.byrank.byname(params[:searchtext])
    @watchlist = compile_watchlist
    render :partial => "search"
  end

  def searchbyfranchise
    picks = Pick.find_all_by_user_id(params[:team], :include => :player)
    @players = picks.map {|x| x.player }
    @watchlist = compile_watchlist(current_user)
    render :partial => "search"
  end

  def searchbyteam
    @players = Player.undrafted.byrank.find_all_by_team(params[:team])
    @watchlist = compile_watchlist(current_user)
    render :partial => "search"
  end

  def searchbypos
    @watchlist = compile_watchlist(current_user)
    case params[:fieldPosition]
    when "BATTERS"
      @players = Player.undrafted.batters.byrank
    when "PITCHERS"
      @players = Player.undrafted.pitchers.byrank
    when "ALL"
      @players = Player.undrafted(:order => "orank asc")
    else
      @players = Player.undrafted.byrank.bypos(params[:fieldPosition])
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

  def add_to_watchlist
    @subject = Watchlist.new(:player_id => params[:id], :user_id => current_user.id)
    @subject.save
  end

  def remove_from_watchlist
    @subject = Watchlist.find_by_player_id(params[:id])
    @subject.destroy
  end

end
