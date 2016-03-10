class AddHeavyLoadingCapacityAndLightLoadingCapacityToGenericUnits < ActiveRecord::Migration
  def self.up
    add_column :generic_units, :heavy_loading_capacity, :integer
    add_column :generic_units, :light_loading_capacity, :integer
  end

  def self.down
    remove_column :generic_units, :heavy_loading_capacity
    remove_column :generic_units, :light_loading_capacity
  end
end
