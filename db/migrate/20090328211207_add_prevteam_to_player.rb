class AddPrevteamToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :previousTeam, :integer
  end

  def self.down
    remove_column :players, :previousTeam
  end
end
