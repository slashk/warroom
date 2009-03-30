class PlayersController < ApplicationController
  before_filter :login_required

  # GET /players
  # GET /players.xml
  def index
    @players = Player.undrafted.byrank
    @teams = User.draftorder
    @watchlist = compile_watchlist

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
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

  # PUT /players/1
  # PUT /players/1.xml
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

  def searchbyteam
    @players = Player.undrafted.byrank.find_all_by_team(params[:team])
    @watchlist = compile_watchlist
    render :partial => "search"
  end

  def searchbypos
    @watchlist = compile_watchlist
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
    @watchlist = compile_watchlist
    w = Watchlist.find_all_by_user_id(current_user, :include => :player)
    @players = w.map {|x| x.player }
    # TODO test this -- should reject players that are watched, but also drafted
    @players = @players.reject {|x| Pick.find_by_player_id(x.player_id)}
    render :partial => "search"
  end

  def add_to_watchlist
    @subject = Watchlist.new(:player_id => params[:id], :user_id => current_user)
    @subject.save
  end

  def remove_from_watchlist
    @subject = Watchlist.find_by_player_id(params[:id])
    @subject.destroy
  end

end
