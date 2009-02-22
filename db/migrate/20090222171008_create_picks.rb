class CreatePicks < ActiveRecord::Migration
  def self.up
    create_table :picks do |t|
      t.integer :player_id,   :null => false
      t.integer :user_id,   :null => false
      t.integer :pick_number,   :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :picks
  end
end
