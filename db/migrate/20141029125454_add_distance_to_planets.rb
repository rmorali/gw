class AddDistanceToPlanets < ActiveRecord::Migration
  def self.up
    add_column :planets, :distance, :integer
  end

  def self.down
    remove_column :planets, :distance
  end
end
