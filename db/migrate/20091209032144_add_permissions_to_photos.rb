class AddPermissionsToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :status, :string
    
  end

  def self.down
    remove_column :photos, :status
    
  end
end
