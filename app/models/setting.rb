class Setting < ActiveRecord::Base

validates_numericality_of :initial_factories,
                          :initial_capital_ships,
                          :initial_fighters,
                          :initial_transports,
                          :initial_troopers,
                          :initial_planets,
                          :initial_credits,
                          :net_planet_income,
                          :bonus_planet_income,
                          :facility_divisor_rate,
                          :facility_upgrade_cost,
                          :capital_ship_upgrade_cost,
                          :maximum_warrior_life,
                          :maximum_fleet_size

  after_save :apply_changes

  def self.getInstance
    Setting.last
  end

  def apply_changes
    Planet.update_income
  end


end
