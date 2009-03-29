class Retainee < ActiveRecord::Base
  belongs_to :player
  belongs_to :user

#  validates_uniqueness_of :player_id, :message => "has already been retained"
#  validates_numericality_of :player_id
#  validates_numericality_of :user_id
end
