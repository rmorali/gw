class Squad < ActiveRecord::Base

  default_scope :order => 'id ASC'

  has_many :planets
  has_many :generic_fleets
  has_many :facility_fleets
  has_many :fleets
  belongs_to :user
  belongs_to :goal
  belongs_to :home_planet, :class_name => "Planet"

  validates_format_of :name, :with => /^[a-zA-Z\d ]*$/i,
:message => "no special characteres."

  def faction=(faction)
    write_attribute(:faction, FACTIONS.rindex(faction))
  end

  def faction
    FACTIONS[read_attribute(:faction)] if read_attribute(:faction)
  end

  def buy unit, quantity, planet
    unless (unit.belongs? faction) and (unit.is_a? Facility) and (credits >= unit.price)
      return false
    end
    debit unit.price
    new_fleet = FacilityFleet.create(:generic_unit => unit, :quantity => quantity, :planet => planet, :balance => 0, :level => 0, :fleet_name => ' ', :round => Round.getInstance.number)
    generic_fleets << new_fleet
    save
  end

  def generate_profits!
    income = 0
    Planet.where(:squad => self).each do |planet|
      income += planet.air_credits if planet.air_credits.present?
    end
    Planet.where(:ground_squad => self).each do |planet|
      income += planet.ground_credits if planet.ground_credits.present?
    end
    self.credits += income
    save
  end

  def change_producing_unit facility_fleet, unit
    facility_fleet.producing_unit = unit
    facility_fleet.save!
  end

  def change_producing_unit2 facility_fleet, unit
    facility_fleet.producing_unit2 = unit
    facility_fleet.save!
  end

  def random_planet_but planet
    planets_array = planets.to_a - [planet]
    return false if planets_array.empty?
    random_planet = planets_array[rand(planets_array.size)]
  end

  def warp_facility_on value, planet
    facilities = Facility.allowed_for(faction).where(:price => value)
    random_facility = facilities[rand(facilities.size)]
    facility = facility_fleets.new(:facility => random_facility, :planet => planet, :balance => random_facility.capacity, :level => 0, :fleet_name => ' ', :round => 0)
    facility.save!
  end

  def warp_units total_value, unit, allowed_price, planet

    if unit == CapitalShip
      until total_value < allowed_price do
        units = unit.allowed_for(faction).where(:price => allowed_price..total_value)
        random_unit = units[rand(units.size)]
        Fleet.create_from_facility random_unit, 1, planet, self
        total_value -= random_unit.price
      end
    else
      units = unit.allowed_for(faction).where(:price => allowed_price)
      random_unit = units[rand(units.size)]
      unit_count = 0
      until total_value < random_unit.price do
        unit_count += 1
        total_value -= random_unit.price
      end
      Fleet.create_from_facility random_unit, unit_count, planet, self
    end
  end

  def populate_planets
    planets.each do |planet|
      settings = Setting.getInstance
      warp_facility_on Setting.getInstance.initial_factories, planet
      warp_units settings.initial_capital_ships, CapitalShip, 350, planet unless settings.initial_capital_ships == 0
      warp_units settings.initial_fighters, Fighter, 1..400, planet unless settings.initial_fighters == 0
      warp_units settings.initial_fighters, Fighter, 1..400, planet unless settings.initial_fighters == 0
      warp_units settings.initial_transports, LightTransport, 1..400, planet unless settings.initial_transports == 0
      warp_units settings.initial_troopers, Trooper, 1..15, planet unless settings.initial_troopers == 0
    end
  end

  def transfer_credits quantity, destination
    if self.credits >= quantity && self != destination
      self.debit quantity
      destination.deposit quantity
    end
  end

  def debit quantity
    update_attributes(:credits => credits - quantity)
  end

  def deposit quantity
    update_attributes(:credits => credits + quantity)
  end

  def ready!
    if self.ready == true
      self.ready = nil
    else
      self.ready = true
    end
    self.save!
    Round.getInstance.check_state
    true
  end

  def flee_tax round
    tax = 0
    Result.where(:squad => self, :round => round).each do |result|
      tax += result.generic_unit.price * result.fled * 0.20 unless result.fled == nil || result.fled <= 0
    end
    tax
  end

end
