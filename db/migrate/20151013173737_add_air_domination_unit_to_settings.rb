class AddAirDominationUnitToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :air_domination_unit, :string
  end

  def self.down
    remove_column :settings, :air_domination_unit
  end
end
