class AddFacilityPrimaryProductionRateToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :facility_primary_production_rate, :integer
  end

  def self.down
    remove_column :settings, :facility_primary_production_rate
  end
end
