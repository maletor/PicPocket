class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string  :title
      t.integer     :size, :height, :width, :parent_id, :position
      t.string      :content_type, :filename, :thumbnail
      t.timestamps
    end
    
    add_index :photos, :parent_id
  end

  def self.down
    drop_table :photos
  end
end
