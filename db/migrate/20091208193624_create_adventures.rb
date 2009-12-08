class CreateAdventures < ActiveRecord::Migration
  def self.up
    create_table :adventures do |t|
      t.references :user
      t.references :event
      t.integer :owner
      
      t.timestamps
    end
  end

  def self.down
    drop_table :adventures
  end
end
