class AddGroundDominationUnitToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :ground_domination_unit, :string
  end

  def self.down
    remove_column :settings, :ground_domination_unit
  end
end
