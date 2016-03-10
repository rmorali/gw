class AddPlanetIdToTradeport < ActiveRecord::Migration
  def self.up
    add_column :tradeports, :planet_id, :integer
  end

  def self.down
    remove_column :tradeports, :planet_id
  end
end
