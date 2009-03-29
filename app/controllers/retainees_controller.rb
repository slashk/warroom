class RetaineesController < ApplicationController
  before_filter :login_required

  def index
    @retainees = Retainee.find(:all, :order => :user_id, :include => [:player, :user])

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @retainee = Retainee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @retainee = Retainee.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @user = User.find(current_user)
    @players = Player.find_all_by_previousTeam(@user)
    r = Retainee.find_all_by_user_id(@user)
    if r.nitems > 0
      rplayers = r.map {|x| x.player_id}
      @retainees = @players.map {|x| x if rplayers.include?(x.id) }
    else
      @retainees = []
    end
  end

  def create
    @retainee = Retainee.new(params[:retainee])

    respond_to do |format|
      if @retainee.save
        flash[:notice] = 'Retainee was successfully created.'
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
      @retainee = Retainee.new(:player_id => params[:id], :user_id => current_user)
      if @retainee.save
        @players = Player.find(params[:id])
      else
        @players = "Error"
      end
    end
  end

  def remove_player_from_retainee_list
    @retainee = Retainee.find_by_player_id(params[:id])
    @retainee.destroy
    @id = params[:id]
  end
  
  private

  def check_compliance(user, newPlayer)
    compliant = true
    player = Player.find(newPlayer)
    retainees = Retainee.find_all_by_user_id(user, :include => :player)
    if player.pos.match(/P/)
      pitchers = retainees.map {|x| x if x.player.pos.match(/P/)}
      compliant = false if pitchers.size > 2
    else
      batters = retainees.map {|x| x if !x.player.pos.match(/P/)}
      compliant = false if batters.size > 2
    end
    # check RP <= 2
    # check OF <= 2
    return compliant
  end

end
