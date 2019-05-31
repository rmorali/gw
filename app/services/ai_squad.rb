class AiSquad
  def initialize(*squad)
    @squad = squad.first
  end

  def new
    Squad.create(:name => 'Bot Squadron', :color => "FF#{rand(99)}#{rand(99)}", :user => User.first, :faction => 'Mercenary', :home_planet => Planet.find(rand(30)), :credits => 1200, :goal => Goal.get_goal, :map_ratio => 100, :map_background => true)
  end

  def act!
    @ai_squad.move!
  end

  def produce
    facilities = FacilityFleet.where(:squad => @squad)

    facilities.each do |f|
      balance = f.planet.balance * 0.50
      planet = f.planet
      capital_ships = CapitalShip.allowed_for(@squad.faction).where('price <= ?', balance)
      capital_ship = capital_ships[rand(capital_ships.count)] unless capital_ships.empty?
      quantity = (balance / capital_ship.price).to_i unless capital_ship.nil?      
      f.produce! capital_ship, quantity, planet, @squad unless quantity.nil?

      balance = f.planet.balance
      fighters = Fighter.allowed_for(@squad.faction).where('price <= ?', balance)
      fighter = fighters[rand(fighters.count)] unless fighters.empty?
      quantity = (balance / fighter.price).to_i unless fighter.nil?
      f.produce! fighter, quantity, planet, @squad unless quantity.nil?
    end
    
  end

  def move
    planets = Planet.select { |p| p.generic_fleets.any? { |f| f.squad == @squad } }
    planets.each do |p|
      p.generic_fleets.each do |f|
        planet = p.routes[rand(p.routes.count)]
        f.destination = planet unless f.type?(Facility)
        f.moving = true unless f.type?(Facility)
        f.save
      end
    end
  end

end

