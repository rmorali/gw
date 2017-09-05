require 'spec_helper'

describe Planet do
  let(:planet) {Factory :planet}

  it {should belong_to :squad}
  it {should have_many :generic_fleets}
  it {should have_many :results}
  it {should belong_to :ground_squad}
  it {should belong_to :first_player}
  it {should belong_to :last_player}

  context '.seen_by squad' do
    before do
      @squad = Factory :squad
      @fleet = Factory :generic_fleet, :planet => planet, :squad => @squad
      planet.squad = @squad
      planet.ground_squad = @squad
      planet.save 
    end
    it 'should find planets where planet has squads on it' do
      Planet.seen_by(@squad).should include planet
    end
    it 'should not include a planet squad doesnt have any ships' do
      not_seen = Factory :planet
      Planet.seen_by(@squad).should_not include not_seen
    end
    it 'should not bring more than one instance of the planet' do
      Factory :generic_fleet, :planet => planet, :squad => @squad
      planets = Planet.seen_by(@squad)
      planets.should == planets.uniq
    end
    it 'should show ownership in the map' do
      planet.owner_visible_to?(@squad).should be_true
    end
    it 'should show ground ownership in the map' do
      planet.ground_owner_visible_to?(@squad).should be_true
    end
    it 'should show its ownerships if a sensor is located nearby' do
      @fleet.destroy
      nearby_planet = Factory :planet
      sar = Factory :skill, :acronym => 'SAR'
      Route.create(:vector_a => planet, :vector_b => nearby_planet, :distance => 1)
      sensor = Factory :generic_fleet, :generic_unit => Factory(:capital_ship), :planet => nearby_planet, :squad => @squad, :skill => sar
      planet.owner_visible_to?(@squad).should be_true
      planet.ground_owner_visible_to?(@squad).should be_true
    end
  end

  it 'should output its full profits if the squad has air and ground ownership and doesnt have an enemy on planet' do
    planet.credits = 1000
    planet.credits_per_turn.should be 0

    squad = Factory :squad
    facility = Factory :generic_fleet, :squad => squad, :generic_unit => Factory(:facility)
    capital_ship = Factory :generic_fleet, :squad => squad, :generic_unit => Factory(:capital_ship)
    trooper = Factory :generic_fleet, :squad => squad, :generic_unit => Factory(:trooper)
    enemy_unit = Factory :generic_fleet, :squad => Factory(:squad), :generic_unit => Factory(:unit)

    planet.generic_fleets << facility
    planet.generic_fleets << capital_ship
    planet.generic_fleets << trooper
    planet.set_ownership
    planet.set_ground_ownership
    planet.credits_per_turn.should be 1000

    planet.generic_fleets << enemy_unit
    planet.set_ownership
    planet.set_ground_ownership
    planet.credits_per_turn.should be 0
  end

  it 'should output a % profits if the squad has air ownership and doesnt have an enemy on planet' do
    planet.credits = 1000
    planet.credits_per_turn.should be 0

    squad = Factory :squad
    capital_ship = Factory :generic_fleet, :squad => squad, :generic_unit => Factory(:capital_ship)
    enemy_trooper = Factory :generic_fleet, :squad => Factory(:squad), :generic_unit => Factory(:trooper)
    
    planet.generic_fleets << capital_ship
    planet.set_ownership
    planet.set_ground_ownership
    planet.credits_per_turn.should be planet.credits * (100 - Setting.getInstance.ground_income_rate) / 100
   
    planet.generic_fleets << enemy_trooper
    planet.set_ownership
    planet.set_ground_ownership
    planet.credits_per_turn.should be 0
  end

  it 'should output a % profits if the squad has ground ownership and doesnt have an enemy on planet' do
    planet.credits = 1000
    planet.credits_per_turn.should be 0

    squad = Factory :squad
    trooper = Factory :generic_fleet, :squad => squad, :generic_unit => Factory(:trooper)
    enemy_unit = Factory :generic_fleet, :squad => Factory(:squad), :generic_unit => Factory(:unit)
    
    planet.generic_fleets << trooper
    planet.set_ownership
    planet.set_ground_ownership
    planet.credits_per_turn.should be (planet.credits * Setting.getInstance.ground_income_rate) / 100
   
    planet.generic_fleets << enemy_unit
    planet.set_ownership
    planet.set_ground_ownership
    planet.credits_per_turn.should be 0
  end

  context 'regarding partial and full ownerships' do
    before(:each) do
      @squad = Factory :squad
      planet.squad = @squad
    end
    it 'should remove its ownership if it doesnt have a capital ship on it' do
      planet.set_ownership
      planet.squad.should be_nil
    end
    it 'should remove its ground ownership if it doesnt have a trooper on it' do
      planet.set_ground_ownership
      planet.ground_squad.should be_nil
    end
    context 'air ownership' do
      let(:capital_ship) {Factory :generic_fleet, :squad => @squad, :generic_unit => Factory(:capital_ship)}

      it 'should change its ownership if it has a specific unit on it' do
        @settings = Setting.getInstance
        @settings.air_domination_unit = 'CapitalShip'
        @settings.save
        planet.generic_fleets << capital_ship
        planet.set_ownership
        planet.squad.should be @squad
      end
    end

    context 'ground ownership' do
      let(:trooper) {Factory :generic_fleet, :squad => @squad, :generic_unit => Factory(:trooper)}

      it 'should change its owner if planet has a specific unit on it' do
        @settings = Setting.getInstance
        @settings.ground_domination_unit = 'Trooper'
        @settings.save
        planet.generic_fleets << trooper
        planet.set_ground_ownership
        planet.ground_squad.should be @squad
      end
    end
  end

  it 'should get a random planet' do
    3.times {Factory :planet}
    Planet.randomize.should be_an_instance_of Planet
  end

  context 'regarding routing system' do
    before do
      squad = Factory :squad
      unit = Factory :capital_ship
      @fleet = Factory(:generic_fleet, :generic_unit => unit, :squad => squad)
      @allied_fleet = Factory(:generic_fleet, :generic_unit => unit, :squad => squad)  
    end
    it 'should find planets adjacent of it' do
      second_planet = Factory :planet
      Factory :route, :vector_a => planet, :vector_b => second_planet
      planet.routes(@fleet).should include(second_planet)
    end
    it 'should have a disable switch for routes' do
      2.times {Factory :planet}
      Planet.disable_routes
      planet.routes(@fleet).should == Planet.all
      Planet.enable_routes
    end
    it 'should find all planets in a sector when it is a capital ship' do
      planet.sector = 1
      planet.save
      3.times { Factory :planet, :sector => 1 }
      @fleet.generic_unit = Factory :capital_ship
      @fleet.save
      planet.routes(@fleet).count.should == 3
    end
    it 'should find all planets in a sector if ENG skill is installed' do
      planet.sector = 1
      planet.save
      3.times { Factory :planet, :sector => 1 }
      @fleet.generic_unit = Factory :capital_ship
      @fleet.save
      eng = Factory :skill, :acronym => 'ENG'
      @engine_skill = Factory :generic_fleet, :generic_unit => eng
      @fleet.install @engine_skill
      planet.routes(@fleet).count.should == 3
    end
    it 'should not find routes for troopers sensors armaments' do
      second_planet = Factory :planet
      Factory :route, :vector_a => planet, :vector_b => second_planet
      @fleet.generic_unit = Factory :trooper
      @fleet.save
      planet.routes(@fleet).should_not include(second_planet)
    end
    it 'should not find routes for fighters without allied units' do
      second_planet = Factory :planet
      third_planet = Factory :planet
      Factory :route, :vector_a => planet, :vector_b => second_planet
      Factory :route, :vector_a => planet, :vector_b => third_planet
      @fleet.generic_unit = Factory :fighter
      @fleet.save
      @allied_fleet.planet = third_planet
      @allied_fleet.save
      planet.routes(@fleet).should_not include(second_planet)
      planet.routes(@fleet).should include(third_planet)
    end
  end
  
  it 'should verify if there is a conflict on planet' do
    2.times {Factory :generic_fleet, :planet => planet}
    planet.should be_under_attack
  end

  it 'should verify if a squad can construct on planet' do
    squad = Factory :squad
    trooper = Factory :generic_fleet, :squad => squad, :generic_unit => Factory(:trooper)
    capital_ship = Factory :generic_fleet, :squad => squad, :generic_unit => Factory(:capital_ship)
    planet.generic_fleets << trooper
    planet.able_to_construct?(squad).should be_true
    facility = Factory :generic_fleet, :squad => squad, :generic_unit => Factory(:facility)
    planet.generic_fleets << facility
    planet.able_to_construct?(squad).should be_true
    another_facility = Factory :generic_fleet, :squad => squad, :generic_unit => Factory(:facility)
    planet.generic_fleets << another_facility
    planet.able_to_construct?(squad).should_not be_true
  end

  it 'should verify if planet has a specific enemy type' do
    squad = Factory :squad
    trooper = Factory :generic_fleet, :generic_unit => Factory(:trooper)
    capital_ship = Factory :generic_fleet, :generic_unit => Factory(:capital_ship)
    planet.generic_fleets << capital_ship
    planet.generic_fleets << trooper
    planet.has_an_enemy?(Fighter, squad).should be_false
    planet.has_an_enemy?(CapitalShip, squad).should be_true
    planet.has_an_enemy?(Trooper, squad).should be_true
  end

  it 'should set 4 random planets as special ' do
    (1..4).each { |i| Factory :planet, :sector => i }
    Planet.randomize_special_planets
    Planet.where(:special => true).count.should == 4
  end

  it 'should update income according to settings' do
    @settings = Setting.getInstance
    (1..4).each { |i| Factory :planet, :sector => i }
    Planet.randomize_special_planets
    Planet.update_income
    Planet.where(:special => true).first.credits.should == @settings.bonus_planet_income
    Planet.where(:special => nil).first.credits.should == @settings.net_planet_income
  end

  context 'selecting the best route for a fleeing fleet' do
    before(:each) do
      @squad = Factory :squad
      @enemy_squad = Factory :squad
      @unit = Factory :fleet, :squad => @squad
      @allied_unit = Factory :fleet, :squad => @squad
      @enemy_unit = Factory :fleet, :squad => @enemy_squad
      @destination1 = Factory(:planet)
      @destination2 = Factory(:planet)
      @destination3 = Factory(:planet)
      @destination1.generic_fleets.destroy_all
      @destination2.generic_fleets.destroy_all
      @destination3.generic_fleets.destroy_all
      planet.generic_fleets.destroy_all
      Route.destroy_all
      planet.generic_fleets << @unit
      route1 = Factory :route, :vector_a => planet, :vector_b => @destination1
      route2 = Factory :route, :vector_a => planet, :vector_b => @destination2
      route3 = Factory :route, :vector_a => planet, :vector_b => @destination3
    end

    it 'should go first to an allied only planet' do
      @destination2.generic_fleets << @enemy_unit
      @destination3.generic_fleets << @allied_unit
      fleeing_fleet = @unit.flee! 1
      fleeing_fleet.planet.should == @destination3
    end

    it 'should go second to a neutral planet' do
      @destination1.squad = @enemy_squad
      @destination1.save
      @destination2.ground_squad = @enemy_squad
      @destination2.save
      fleeing_fleet = @unit.flee! 1
      fleeing_fleet.planet.should == @destination3
    end

    it 'should go last to an enemy planet' do
      @destination1.generic_fleets << @enemy_unit
      @destination2.generic_fleets << @enemy_unit
      @destination3.generic_fleets << @enemy_unit        
      fleeing_fleet = @unit.flee! 1
      fleeing_fleet.planet.should == @destination1 || fleeing_fleet.planet.should == @destination2 || fleeing_fleet.planet.should == @destination3  
    end
  end

  context 'calculating fleet size' do
    before do
      @planet = Factory :planet
      @round = Round.getInstance
      @setting = Factory :setting
      @fighter = Factory(:generic_fleet, :generic_unit => Factory(:fighter), :squad => Factory(:squad), :planet => @planet)
      @light_transport = Factory(:generic_fleet, :generic_unit => Factory(:light_transport), :squad => Factory(:squad), :planet => @planet)
      @armament = Factory(:generic_fleet, :generic_unit => Factory(:armament), :squad => Factory(:squad), :planet => @planet)
      Result.create_all
    end

    it 'should calculate the size of each squad fleets' do
      count_fleets = @fighter.quantity * @fighter.generic_unit.price + @light_transport.quantity * @light_transport.generic_unit.price + @armament.quantity * @armament.generic_unit.price
      fleet_total = 0
      @planet.count_fleets.each do |count|
        fleet_total += count[1]
      end  
      fleet_total.should == count_fleets
    end

    it 'should inform how many player in a combat according its fleets size' do
      @planet.players_quantity.should == '1 x 1'
      #TODO
      #@planet.players_quantity.should == '2 x 2'
    end
  end

end
