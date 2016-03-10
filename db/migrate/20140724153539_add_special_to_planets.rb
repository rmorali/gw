class AddSpecialToPlanets < ActiveRecord::Migration
  def self.up
    add_column :planets, :special, :boolean
  end

  def self.down
    remove_column :planets, :special
  end
end
