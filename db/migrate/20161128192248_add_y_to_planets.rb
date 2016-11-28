class AddYToPlanets < ActiveRecord::Migration
  def self.up
    add_column :planets, :y, :integer
  end

  def self.down
    remove_column :planets, :y
  end
end
