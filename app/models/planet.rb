class Planet < ActiveRecord::Base
  default_scope :order => "name ASC"
  scope :seen_by, lambda {|squad| joins(:generic_fleets).where(:generic_fleets => {:squad => squad}).group("planets.id")}
  scope :fog_seen_by, lambda {|squad| joins(:results).where(:results => {:squad => squad}).group("planets.id")}

  belongs_to :squad
  has_many :generic_fleets
  has_many :results
  belongs_to :ground_squad, :class_name => "Squad"
  belongs_to :first_player, :class_name => "Squad"
  belongs_to :last_player, :class_name => "Squad"
  @@disable_routes = false

  def credits_per_turn
    (self.air_credits + self.ground_credits).to_i
  end

  def air_credits
   return (self.credits * (100 - Setting.getInstance.ground_income_rate) / 100).to_i unless self.squad == nil or generic_fleets.any?{|fleet| fleet.squad != self.squad}
   0
  end

  def ground_credits
   return ((self.credits * Setting.getInstance.ground_income_rate ) / 100).to_i unless self.ground_squad == nil or generic_fleets.any?{|fleet| fleet.squad != self.ground_squad}
   0
  end

  def set_ownership
    if has_a? Setting.getInstance.air_domination_unit.constantize and !self.under_attack?
      air_units = generic_fleets.select {|fleet| fleet.type? Setting.getInstance.air_domination_unit.constantize }
      air_units.sort! { |one,other| one.updated_at <=> other.updated_at }
      self.squad = air_units.first.squad
      save
    else
      self.squad = nil
      save
    end
  end

  def set_ground_ownership
    if has_a? Setting.getInstance.ground_domination_unit.constantize and !self.under_attack?
      ground_units = generic_fleets.select {|fleet| fleet.type? Setting.getInstance.ground_domination_unit.constantize }
      ground_units.sort! { |one,other| one.updated_at <=> other.updated_at }
      self.ground_squad = ground_units.first.squad
      save
    else
      self.ground_squad = nil
      save
    end
  end

  def self.randomize
      empty_planets = self.where(:squad_id => nil, :wormhole => nil, :tradeport => nil)
      empty_planets[rand(empty_planets.count)]
  end

  def self.randomize_by_sector(number)
      empty_planets = self.where(:squad_id => nil, :wormhole => nil, :sector => number)
      empty_planets[rand(empty_planets.count)]
  end

  def self.create_wormholes
    side_a = Planet.randomize_by_sector(1)
    side_a.update_attributes(:wormhole => true)
    side_b = Planet.randomize_by_sector(3)
    side_b.update_attributes(:wormhole => true)
    Route.create(:vector_a => side_a, :vector_b => side_b, :distance => 2)
    side_a = Planet.randomize_by_sector(2)
    side_a.update_attributes(:wormhole => true)
    side_b = Planet.randomize_by_sector(4)
    side_b.update_attributes(:wormhole => true)
    Route.create(:vector_a => side_a, :vector_b => side_b, :distance => 2)
  end

  def self.randomize_special_planets
    for i in 1..4
      planet = Planet.randomize_by_sector(i)
      planet.update_attributes(:special => true)
    end
  end

  def self.update_income
    @settings = Setting.getInstance
    Planet.where(:tradeport => nil).each do |planet|
      if planet.special?
        planet.update_attributes(:credits => @settings.bonus_planet_income)
      else
        planet.update_attributes(:credits => @settings.net_planet_income)
      end
    end
  end

  def self.disable_routes
    @@disable_routes = true
  end

  def self.enable_routes
    @@disable_routes = false
  end

  def has_a?(type)
    generic_fleets.any?{|fleet| fleet.type? type and fleet.moving != true}
  end

  def has_an_enemy?(type, current_squad)
    generic_fleets.any?{|fleet| fleet.type? type and fleet.squad != current_squad}
  end

  def routes(fleet='None')
    return Planet.all if @@disable_routes
    planets = []
    routes = Route.where({:vector_a => self} | {:vector_b => self})
    routes.each do |route|
      planets << route.vector_a
      planets << route.vector_b
    end
    unless fleet == 'None'
      case fleet.generic_unit.type
        when 'Facility'

        when 'CapitalShip'
          routes = Planet.where(:sector => self.sector)
          routes.each do |route|
            planets << route if (fleet.skill && fleet.skill.acronym == 'ENG')
          end
        when 'LightTransport'
          routes = Planet.where(:sector => self.sector)
          routes.each do |route|
            planets << route
          end
        when 'Fighter'
          planets = []
          routes = Route.where({:vector_a => self} | {:vector_b => self})
          routes.each do |route|
            planets << route.vector_a if route.vector_a.generic_fleets.any? { |unit| unit.squad == fleet.squad }
            planets << route.vector_b if route.vector_b.generic_fleets.any? { |unit| unit.squad == fleet.squad }
          end
        when 'Warrior'

        else
          planets = []
      end
    end

    planets.reject! {|planet| planet == self}
    planets.uniq
  end

  def best_route_for(squad)
    planets = []
    route = Route.where({:vector_a => self} | {:vector_b => self})
      route.each do |route|
        planets << route.vector_a
        planets << route.vector_b
      end
    planets.reject! {|planet| planet == self}
    routes = planets.uniq

    flee_routes = routes.select { |planet| planet.generic_fleets.any? { |unit| unit.squad == squad } && planet.squads.count == 1 }
    flee_routes = routes.select { |planet| planet.squad == nil && planet.ground_squad == nil} if flee_routes.empty?
    flee_routes = routes if flee_routes.empty?
    flee_routes.first
      
  end

  def squads
    squads = []
    generic_fleets.each do |fleet|
      squads << fleet.squad 
    end
    squads.uniq
  end

  def to_s
    name
  end

  def under_attack?
    if GenericFleet.where(:planet => self).count(:all, :group => :squad).count > 1
      true
    else
      false
    end
  end

  def able_to_construct?(squad)
    if generic_fleets.any?{|fleet| fleet.squad != squad} or self.tradeport?
      permission = nil
    else
      permission = true
    end
    permission = nil if self.count_facilities_of(squad) > Setting.getInstance.maximum_facilities
    permission
  end

  def count_facilities_of(squad)
    self.generic_fleets.select { |fleet| fleet.type?(Facility) && fleet.squad == squad }.count  
  end

  def owner_visible_to?(squad)
    true if ( self.squad && self.generic_fleets.any? { |fleet| fleet.squad == squad } ) || ( self.squad && self.routes.any? { |planet| planet.generic_fleets.any? { |fleet| fleet.squad == squad && fleet.is_a_sensor? } } ) && Round.getInstance.move?
  end

  def ground_owner_visible_to?(squad)
    true if ( self.ground_squad && self.generic_fleets.any? { |fleet| fleet.squad == squad } ) || ( self.ground_squad && self.routes.any? { |planet| planet.generic_fleets.any? { |fleet| fleet.squad == squad && fleet.is_a_sensor? } } ) && Round.getInstance.move?
  end

  def count_fleets
    fleet = []
    self.squads.each do |squad|
      fleet_price = 0
      self.results.where(:round => Round.getInstance, :squad => squad).each do |result|
        fleet_price += result.quantity * result.generic_unit.price if result.generic_fleet.type?(Fighter) || result.generic_fleet.type?(LightTransport) || result.generic_fleet.type?(Armament)
      end
      fleet << [squad.name, fleet_price]   
    end
    fleet
  end

  def players_quantity
      limit = nil
      self.count_fleets.each do |count|
        limit = true if count[1] < Setting.getInstance.maximum_fleet_size
      end 
    if limit == true
      "1 x 1"
    else
      "2 x 2"
    end   
  end

  def calculate_fleet_size_for(squad)
    fleet_price = 0
      self.results.where(:round => Round.getInstance, :squad => squad).each do |result|
        fleet_price += result.quantity * result.generic_unit.price
      end
    fleet_price
  end

  def constructive_capacity
    facilities = generic_fleets.where(:type => 'FacilityFleet').sum(:balance)
  end

  def update_balance
    self.balance += constructive_capacity
    self.save
  end

end

