class AddInitialCapitalShipsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :initial_capital_ships, :integer
  end

  def self.down
    remove_column :settings, :initial_capital_ships
  end
end
