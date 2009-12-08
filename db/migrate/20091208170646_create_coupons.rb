class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :sponsor_code
      t.decimal :amount, :precision => 8, :scale => 2
      t.text :description
      t.string :steganography

      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
