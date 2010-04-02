class AdminController < ApplicationController
  before_filter :admin_role_required

  def index
    # this is the control panel: buttons and status
    @players_total_count = Player.count
    @players_undrafted_count = Player.undrafted.count
    @picks_total_count = Pick.count
    @picks_undrafted_count = Pick.find_all_by_player_id("null").count
    @picks = Pick.all
  end

  def new    
  end

  def create
    if !params[:rounds].nil? &&  (1..100).include?(params[:rounds].to_i)
      users = User.all(:order => "draft_order asc")
      if params[:draft_type] == "snake"
        draft = set_snake(users, params[:rounds].to_i)
      else
        draft = set_straight(users,params[:rounds].to_i)
      end
      # destroy all current picks if drop_draft
      if params[:drop_draft]
        Pick.all.each do |x|
          x.destroy
        end
      end
      # create the new draft
      make_it(draft)
      if params[:copy_retainee]
        copy_retainees_to_draft
      end
    else
      flash[:error] = "Rounds must be 1 and 100"
    end
    redirect_to :action => "index"
  end

  private

  def set_snake(users, rounds)
    # users is a array of user objects in draft_pick asc order
    league_size = users.size
    # this one is tough because it goes 1,2,3,3,2,1
    # create the two rounds with users.fwd concat'd with users.reverse
    full_rounds = users + users.reverse
    # do the draft with full_round instead of just single rounds
    z = 0
    draft = Hash.new
    (rounds/2).times do |x|
      full_rounds.each do |u|
        z = z + 1
        draft[z] = u.id
      end
    end
    z = full_rounds.count * (rounds/2)
    # if there was an odd number, add another fwd round
    if rounds % 2
      # add another fwd round
      users.each do |u|
        z = z + 1
        draft[z] = u.id
      end
    end
    # return hash of pick_number => user.id
    return draft
  end

  def set_straight(users, rounds)
    # users is a array of user objects in draft_pick asc order
    league_size = users.size
    z = 0
    draft = Hash.new
    rounds.times do |x|
      users.each do |u|
        z = z + 1
        draft[z] = u.id
      end
    end
    return draft
  end

  def make_it(draft)
    # draft is a hash of pick_number => user_id
    draft.keys.sort.each do |x|
      draft_slot = Pick.new(:pick_number => x, :user_id => draft[x])
      draft_slot.save
    end
  end
  
  def copy_retainees_to_draft
    retainees = Retainee.all
    retainees.each do |r|
      draft_choice = Pick.remaining.first
      draft_choice.player_id = r.player_id
      draft_choice.user_id = r.user_id
      draft_choice.save
    end
  end
  
end
