class Pick < ActiveRecord::Base
  belongs_to :player
  belongs_to :user
  validates_uniqueness_of :pick_number, :message => "was already taken"
  validates_numericality_of :user_id

  named_scope :taken, :conditions => "player_id IS NOT NULL", :order => "pick_number desc", :include => [:player, :user]
  named_scope :taken_limited, lambda {|x| {:conditions => "player_id IS NOT NULL", :order => "pick_number desc", :include => [:player, :user], :limit => x}}
  named_scope :remaining, lambda {|x| {:conditions => "pick_number >= #{x}", :order => "pick_number asc", :limit => 10, :include => :user}}
  named_scope :current, :conditions => "player_id IS NULL", :order => 'pick_number asc', :limit => 1
  
end
