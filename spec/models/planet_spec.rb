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
   #TODO verificar se pode construir se o apoio no planeta for maior que x%
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

  context 'calculate domination' do
    it 'retrieves serialized domination data' do
      planet.domination = { 1 => 40, 2 => 60 }
      planet.save
      expect(planet.domination).to include { '2 => 60' }
      first_squad_presence = planet.domination[1]
      expect(first_squad_presence).to eq(40)
      second_squad_presence = planet.domination[2]
      expect(second_squad_presence).to_not eq(40)
    end
  end

end
