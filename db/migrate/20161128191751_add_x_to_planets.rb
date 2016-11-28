class AddXToPlanets < ActiveRecord::Migration
  def self.up
    add_column :planets, :x, :integer
  end

  def self.down
    remove_column :planets, :x
  end
end
