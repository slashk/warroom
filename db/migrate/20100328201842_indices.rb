class Indices < ActiveRecord::Migration
  def self.up
    # player index
    add_index :players, :player
    add_index :players, :yahoo_ref
    add_index :players, :pos
    add_index :players, :team
    add_index :players, :rank
    add_index :players, :orank
    add_index :players, :previousTeam
    # picks index
    add_index :picks, :player_id
    add_index :picks, :user_id
    # retainees index
    add_index :retainees, :user_id
    add_index :retainees, :player_id
    # watchlists
    add_index :watchlists, :player_id
    add_index :watchlists, :user_id
  end

  def self.down
    remove_index :watchlists, :user_id
    remove_index :watchlists, :player_id
    remove_index :retainees, :player_id
    remove_index :retainees, :user_id
    remove_index :picks, :user_id
    remove_index :picks, :player_id
    remove_index :players, :previousTeam
    remove_index :players, :orank
    remove_index :players, :rank
    remove_index :players, :team
    remove_index :players, :pos
    remove_index :players, :yahoo_ref
    remove_index :players, :player
  end
end
