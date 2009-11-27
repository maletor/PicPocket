class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.string :sponsor
      t.string :product_name
      t.time :video_length
      t.timestamps
    end
  end
  
  def self.down
    drop_table :ads
  end
end
