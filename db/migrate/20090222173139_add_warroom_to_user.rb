class AddWarroomToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :team_id, :integer
    add_column :users, :role, :string
  end

  def self.down
    remove_column :users, :role
    remove_column :users, :team_id
  end
end
