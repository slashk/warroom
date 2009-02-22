class AddWarroomToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :team_id, :integer
    add_column :users, :role, :string

    # team data
    add_column :users, :draft_order, :integer, :default => 1
    add_column :users, :team, :string

  end

  def self.down
    remove_column :users, :role
    remove_column :users, :team_id

    remove_column :users, :draft_order
    remove_column :users, :team
  end
end
