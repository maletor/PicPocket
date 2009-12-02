class AddPhoneToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :phone, :integer
  end

  def self.down
    add_column :users, :phone, :integer
  end
end
