class RetaineesController < ApplicationController
  before_filter :login_required

  def index
    @retainees = Retainee.find(:all, :order => :user_id, :include => [:player, :user])
    @user = User.find(current_user)
  end

  def show
    @retainee = Retainee.find(params[:id])
  end

  def new
    @retainee = Retainee.new
  end

  def edit
    @user = User.find(current_user)
    @players = Player.find_all_by_previousTeam(@user)
    @retainees = Retainee.find_all_by_user_id(@user).map {|x| x.player}
    @retained_pool = @retainees.nil? ? [] : @retainees.map {|x| x.id}
  end

  def create
    @retainee = Retainee.new(params[:retainee])

    respond_to do |format|
      if @retainee.save
        flash[:notice] = 'Retainee List was successfully created.'
        format.html { redirect_to(@retainee) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @retainee = Retainee.find(params[:id])

    respond_to do |format|
      if @retainee.update_attributes(params[:retainee])
        flash[:notice] = 'Retainee was successfully updated.'
        format.html { redirect_to(@retainee) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @retainee = Retainee.find(params[:id])
    @retainee.destroy

    respond_to do |format|
      format.html { redirect_to(retainees_url) }
    end
  end

  def add_player_to_retainee_list
    if check_compliance(current_user, params[:id])
      @retainee = Retainee.new(:player_id => params[:id], :user_id => current_user.id)
      if @retainee.save
        @players = Player.find(params[:id])
        returnMessage = "OK"
        status = 200
      else
        returnMessage = "ERROR"
        status = 404
      end
    end
    render :text => returnMessage, :status => status
  end

  def remove_player_from_retainee_list
    @retainee = Retainee.find_by_player_id(params[:id])
    @retainee.destroy
    @id = params[:id]
    render :nothing => true
  end
  
  def retained_players
    @retainees = Retainee.find_all_by_user_id(current_user).map {|x| x.player}
    render :partial => "selectedPlayers", :collection => @retainees
    @limit_text = "You may retain #{3-countBatters(@retainees)} more batters and #{3-countPitchers(@retainees)} more pitchers"
  end
  
  private

  def check_compliance(user, newPlayer)
    # At the end of this season, each team will be able retain up to
    # six (6) players: three offensive and three pitchers. Each team can
    # retain a maximum of two outfielders and two relievers in their six
    # players. A team may decide to retain fewer than six players.
    compliant = true
    player = Player.find(newPlayer)
    retainees = Retainee.find_all_by_user_id(user, :include => :player)
    if player.pos.match(/P/)
      pitchers = retainees.map {|x| x if x.player.pos.match(/P/)}
      pitchers.compact!
      compliant = false if pitchers.size > 2
    else
      batters = retainees.map {|x| x if !x.player.pos.match(/P/)}
      batters.compact!
      compliant = false if batters.size > 2
    end
    # TODO check RP <= 2
    # TODO check OF <= 2
    logger.debug "compliant is #{compliant}"
    return compliant
  end

end
