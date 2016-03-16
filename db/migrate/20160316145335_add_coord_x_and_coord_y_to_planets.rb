class AddCoordXAndCoordYToPlanets < ActiveRecord::Migration
  def self.up
    add_column :planets, :coord_x, :integer
    add_column :planets, :coord_y, :integer
  end

  def self.down
    remove_column :planets, :coord_y
    remove_column :planets, :coord_x
  end
end
