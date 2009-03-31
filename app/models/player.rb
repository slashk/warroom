class Player < ActiveRecord::Base
  has_one :pick
  validates_numericality_of :yahoo_ref
  validates_presence_of :player, :pos

  # named scopes
  named_scope :byrank, {:order => "orank asc", :limit => 150}
  named_scope :undrafted, :joins => 'LEFT JOIN picks ON players.id=picks.player_id', :conditions => "picks.id IS NULL"
  named_scope :byname, lambda {|name| {:conditions => ["player LIKE ?", "%#{name}%"]}}
  named_scope :bypos, lambda {|pos| {:conditions => ["pos like ?", "%#{pos}%"]}}
  named_scope :batters, {:conditions => ["pos not like ?", "%P%"]}
  named_scope :pitchers, {:conditions => ["pos like ?", "%P%"]}
end
