class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.string :sponsor
      t.string :product
      t.string :href
      t.decimal :video_length, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :ads
  end
end
