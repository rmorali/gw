class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :net_planet_income
      t.integer :bonus_planet_income
      t.integer :facility_divisor_rate
      t.integer :facility_upgrade_cost
      t.integer :capital_ship_upgrade_cost
      t.integer :maximum_warrior_life
      t.boolean :upgradable_capital_ships
      t.boolean :editable_automatic_results      
    end
  end

  def self.down
    drop_table :settings
  end
end
