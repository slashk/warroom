class Player < ActiveRecord::Base
  has_one :pick
  has_one :retainee
  validates_numericality_of :yahoo_ref
  validates_uniqueness_of :yahoo_ref, :message => "must be unique"
  validates_presence_of :player, :pos, :team

  # named scopes
  named_scope :byrank, {:order => "orank asc"}
  named_scope :undrafted, :joins => 'LEFT JOIN picks ON players.id=picks.player_id', :conditions => "picks.id IS NULL"
  named_scope :limited, :limit => 150
  named_scope :byname, lambda {|name| {:conditions => ["player LIKE ?", "%#{name}%"]}}
  named_scope :bypos, lambda {|pos| {:conditions => ["pos like ?", "%#{pos}%"]}}
  named_scope :batters, {:conditions => ["pos not like ?", "%P%"]}
  named_scope :pitchers, {:conditions => ["pos like ?", "%P%"]}
  
  def is_pitcher?
    self.pos.include? "P"
  end

  def is_batter?
    !self.pos.include? "P"
  end
    
end
