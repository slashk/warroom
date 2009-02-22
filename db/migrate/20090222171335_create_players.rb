class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players, :options => 'default charset=utf8' do |t|
      t.integer :yahoo_ref,  :default => 0
      t.string :player
      t.string :team
      t.string :pos
      t.string :status
      t.integer :rank, :default => 1300
      t.float :IP
      t.integer :W
      t.integer :SV
      t.integer :K
      t.float :ERA
      t.float :WHIP
      t.integer :R
      t.integer :HR
      t.integer :RBI
      t.integer :SB
      t.float :AVG
      t.integer :orank
      t.integer :AB
      t.integer :prank
      t.integer :depth
      t.string :note
      t.integer :pW
      t.integer :pSV
      t.integer :pK
      t.float :pERA
      t.float :pWHIP
      t.integer :pR
      t.integer :pHR
      t.integer :pRBI
      t.integer :pSB
      t.float :pAVG

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
