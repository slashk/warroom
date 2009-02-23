class Player < ActiveRecord::Base
  has_one :pick
  validates_numericality_of :yahoo_ref
  validates_presence_of :player, :pos

  # named scopes
  # player by franchise
  # player by pos
  # player by team
  named_scope :undrafted, :joins => 'LEFT JOIN picks ON players.id=picks.player_id' #, :include => [:pick]

end
