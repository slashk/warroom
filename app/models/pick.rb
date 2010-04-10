class Pick < ActiveRecord::Base
  belongs_to :player
  belongs_to :user
  validates_uniqueness_of :pick_number, :message => "was already taken"
  validates_numericality_of :user_id

  named_scope :taken, 
    :conditions => "player_id IS NOT NULL", 
    :order => "pick_number desc", 
    :include => [:player, :user]
  named_scope :remaining, 
    :conditions => "player_id IS NULL", 
    :order => "pick_number asc", 
    :include =>  :user
  named_scope :current, 
        :conditions => "player_id IS NULL", 
        :order => 'pick_number asc', 
        :limit => 1        
  named_scope :on_podium, 
    :conditions => "player_id IS NOT NULL", 
    :order => "pick_number desc",
    :include => [:player, :user],
    :limit => 1
  
  # these named scopes don't work correctly due to a Rails bug in 2.3.5
  # named_scope :taken_limited, 
  #     :conditions => "player_id IS NOT NULL", 
  #     :order => "pick_number desc", 
  #     :include => [:player, :user], 
  #     :limit => 10
  # named_scope :remaining_limited, 
  #     :conditions => "player_id IS NULL", 
  #     :order => "pick_number asc", 
  #     :include =>  :user, 
  #     :limit => 10
  # named_scope :limited, 
  #     :limit => 10
  
end
