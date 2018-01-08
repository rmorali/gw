class AddDominationToPlanets < ActiveRecord::Migration
  def self.up
    add_column :planets, :domination, :string
  end

  def self.down
    remove_column :planets, :domination
  end
end
