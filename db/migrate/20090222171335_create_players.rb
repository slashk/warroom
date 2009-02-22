class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players, :options => 'default charset=utf8' do |t|
      t.integer :yahoo_ref,  :default => 0
      t.string :player
      t.string :team
      t.string :pos
      t.string :status
      t.integer :rank, :default => 1300
      t.real :IP
      t.integer :W
      t.integer :SV
      t.integer :K
      t.real :ERA
      t.real :WHIP
      t.integer :R
      t.integer :HR
      t.integer :RBI
      t.integer :SB
      t.real :AVG
      t.integer :orank
      t.integer :AB
      t.integer :prank
      t.integer :depth
      t.string :note
      t.integer :pW
      t.integer :pSV
      t.integer :pK
      t.real :pERA
      t.real :pWHIP
      t.integer :pR
      t.integer :pHR
      t.integer :pRBI
      t.integer :pSB
      t.real :pAVG


      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
