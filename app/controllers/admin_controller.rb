class AdminController < ApplicationController
  def pick

  end

  def create_draft
    if params[:draft_type] == "snake"
      # get draft order hash
      # destroy all current picks
      # new and save Pick.new(:pick_number => draft.key, :team_id => draft.value)
    end
  end

  def player
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
        # puts "#{z}. #{u.team}"
        draft[z] = u.id
      end
    end
    z = full_rounds.count * (rounds/2)
    # if there was an odd number, add another fwd round
    if rounds % 2
      # add another fwd round
      users.each do |u|
        z = z + 1
        # puts "#{z}. #{u.team}"
        draft[z] = u.id
      end
    end
    # return hash of pick_number{user.id}
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
        # puts "#{z}. #{u.team}"
        draft[z] = u.id
      end
    end
    return draft
  end

  def make_it
    draft.keys.sort.each do |x|
      a = Pick.new(:pick_number => x, :user_id => draft[x])
      puts "#{a.pick_number}. #{a.user_id}"
    end
  end

end
