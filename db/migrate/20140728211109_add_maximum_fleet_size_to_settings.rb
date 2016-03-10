class AddMaximumFleetSizeToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :maximum_fleet_size, :integer
  end

  def self.down
    remove_column :settings, :maximum_fleet_size
  end
end
