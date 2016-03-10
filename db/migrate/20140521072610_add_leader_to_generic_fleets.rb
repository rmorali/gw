class AddLeaderToGenericFleets < ActiveRecord::Migration
  def self.up
    add_column :generic_fleets, :leader, :boolean
  end

  def self.down
    remove_column :generic_fleets, :leader
  end
end
