class AddFacilityUpgradeRateToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :facility_upgrade_rate, :integer
  end

  def self.down
    remove_column :settings, :facility_upgrade_rate
  end
end
