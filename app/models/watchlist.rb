class Watchlist < ActiveRecord::Base
  belongs_to :player
  belongs_to :user

  validates_uniqueness_of :player_id
end
