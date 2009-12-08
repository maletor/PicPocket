class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.references :user
      t.string :title
      t.string :category
      t.datetime :start_time
      t.datetime :finish_time
      t.string :address
      t.text :info
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :events
  end
end
