class Unretainable < ActiveRecord::Migration
  def self.up
    add_column :players, :unretainable, :boolean, :default => false
  end

  def self.down
    remove_column :players, :unretainable
  end
end
