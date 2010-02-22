class Pick < ActiveRecord::Base
  belongs_to :player
  belongs_to :user
  validates_uniqueness_of :pick_number, :message => "was already taken"
  validates_numericality_of :user_id

  named_scope :picks_taken, :conditions => "player_id IS NOT NULL", :order => "pick_number desc", :include => [:player, :user]
  named_scope :upcoming_picks, lambda {|x| {:conditions => "pick_number >= #{x}", :order => "pick_number asc", :limit => 10, :include => :user}}
  
end
