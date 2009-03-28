class CreateRetainees < ActiveRecord::Migration
  def self.up
    create_table :retainees do |t|
      t.integer :user_id
      t.integer :player_id

      t.timestamps
    end
  end

  def self.down
    drop_table :retainees
  end
end
