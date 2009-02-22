class Pick < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  validates_uniqueness_of :player_id, :message => "has already been drafted"
  validates_uniqueness_of :pick_number, :message => "was already been taken"
  validates_numericality_of :player_id
  validates_numericality_of :team_id
end
