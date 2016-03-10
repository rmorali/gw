class AddFacilitySecondaryProductionRateToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :facility_secondary_production_rate, :integer
  end

  def self.down
    remove_column :settings, :facility_secondary_production_rate
  end
end
