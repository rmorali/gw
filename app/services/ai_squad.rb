class AiSquad
  def initialize(*squad)
    @squad = squad.first
  end

  def create!
    color = ([*('A'..'F'),*('0'..'9')]-%w(0 1 I O)).sample(4).join
    planets = Planet.select { |p| p.generic_fleets.empty? }
    planet = planets[rand(planets.count)]
    Squad.create(:name => 'Bot Squadron', :color => "FF#{color}", :user => User.first, :faction => 'mercenary', :home_planet => planet, :credits => 1200, :goal => Goal.get_goal, :map_ratio => 100, :map_background => true, :ai => true)
  end

  def act!
    self.build
    self.produce unless Round.getInstance.number == 1
    self.move
    @squad.ready!
  end

  def produce
    facilities = FacilityFleet.where(:squad => @squad)

    facilities.each do |f|
      balance_for_capital_ships = f.planet.balance * 0.40
      balance_for_fighters = f.planet.balance * 0.40
      balance_for_light_transports = f.planet.balance * 0.20
      
      planet = f.planet
      capital_ships = CapitalShip.allowed_for(@squad.faction).where('price <= ?', balance_for_capital_ships)
      capital_ship = capital_ships[rand(capital_ships.count)] unless capital_ships.empty?
      quantity = (balance_for_capital_ships / capital_ship.price).to_i unless capital_ship.nil?      
      f.produce! capital_ship, quantity, planet, @squad unless quantity.nil?

      fighters = Fighter.allowed_for(@squad.faction).where('price <= ?', balance_for_fighters)
      fighter = fighters[rand(fighters.count)] unless fighters.empty?
      f_quantity = (balance_for_fighters / fighter.price).to_i unless fighter.nil?
      f.produce! fighter, f_quantity, planet, @squad unless f_quantity.nil?
      
      light_transports = LightTransport.allowed_for(@squad.faction).where('price <= ?', balance_for_light_transports)
      light_transport = light_transports[rand(light_transports.count)] unless light_transports.empty?
      lt_quantity = (balance_for_light_transports / light_transport.price).to_i unless light_transport.nil?
      f.produce! light_transport, lt_quantity, planet, @squad unless lt_quantity.nil?
    end
  end

  def move
    planets = Planet.select { |p| p.generic_fleets.any? { |f| f.squad == @squad } }
    planets.each do |p|
      p.generic_fleets.each do |f|
        stay_in_defense = 0
        stay_in_defense = rand(1..2) if p.generic_fleets.any? { |f| f.squad == @squad && f.type?(Facility) }
        unless stay_in_defense == 2
          planet = choose_destination(p.routes)
          f.destination = planet unless f.type?(Facility)
          f.moving = true unless f.type?(Facility)
          f.save
        end
      end
    end
  end
  
  def build
    unless @squad.credits < 1200
      planets = Planet.select { |p| p.generic_fleets.any? { |f| f.squad == @squad } }
      planet = planets[rand(planets.count)] unless planets.empty?
      facilities = Facility.allowed_for(@squad.faction).where('price <= ?', @squad.credits) unless planet.nil?
      facility = facilities[rand(facilities.count)] unless facilities.empty?
      @squad.buy facility, 1, planet unless facility.nil?
    end
  end
  
  def choose_destination(routes)
    enemy_planets = routes.select { |r| r.generic_fleets.any? { |f| f.squad != @squad } }
    routes = enemy_planets unless enemy_planets.empty?
    destination = routes[rand(routes.count)]
    destination    
  end
  
  

end

