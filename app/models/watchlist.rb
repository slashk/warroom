class Watchlist < ActiveRecord::Base
  belongs_to :player
  belongs_to :user

  named_scope :mine, lambda {|user| {:joins => 'LEFT JOIN picks ON watchlists.player_id=picks.player_id', :conditions => ["watchlists.user_id = ? AND picks.player_id IS NULL",user], :include => [:player, :user]}}
  
end
