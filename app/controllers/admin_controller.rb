class AdminController < ApplicationController
  before_filter :admin_role_required

  def index
    # this is the control panel: buttons and status

  end

  def create
    users = User.all(:order => "draft_order asc")
    if params[:draft_type] == "snake"
      draft = set_snake(users, params[:rounds])
    else
      draft = set_straight(users,params[:rounds])
    end
    # destroy all current picks
    Pick.all.each do |x|
      x.destroy
    end
    # create the new draft
    make_it(draft)
    # find all draft picks to show admin
  end

  def yahoo
  end

  def previous
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

  def straight(users, rounds)
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
  
  def show_git_version
    return system("git rev-parse HEAD")
  end

end
