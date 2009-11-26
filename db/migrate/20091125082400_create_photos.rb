class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer     :size, :height, :width, :parent_id, :attachable_id, :position
      t.string      :content_type, :filename, :thumbnail, :attachable_type
      t.timestamps
    end
    
    add_index :photos, :parent_id
    add_index :photos, [:attachable_id, :attachable_type]
  end

  def self.down
    remove_index :photos, :parent_id
    remove_index :photos, [:attachable_id, :attachable_type]
    drop_table :photos
  end
end
