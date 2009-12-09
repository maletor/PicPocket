class AddFlagsToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :flagged, :boolean
    add_column :photos, :flag_count, :integer, :default => 0
  end

  def self.down
    remove_column :photos, :flagged
    remove_column :photos, :flag_count
    
  end
end
