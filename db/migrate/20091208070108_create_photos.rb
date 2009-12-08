class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.references :user
      t.references :event
      t.datetime :photo_timestamp
      
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
