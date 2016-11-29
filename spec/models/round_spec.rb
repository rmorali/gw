require 'spec_helper'

describe Round do
    
  it {should have_many :results}

  rebel = Factory :squad
  empire = Factory :squad
  4.times { Factory :goal }

  context 'beginning a new round' do
    before do
      #empire.destroy # stinking empire!
      @round = Round.getInstance
      @settings = Setting.getInstance
      rebel.planets.clear
      rebel.facility_fleets.clear
      Factory :fighter, :price => 100
      Factory :facility, :price => 1200
      Factory :light_transport, :price => 100
      Factory :warrior, :price => 50
      Factory :warrior, :price => 45
      Factory :warrior, :price => 40
      Factory :capital_ship, :price => 500
      Factory :trooper, :price => 10
      Factory :armament, :price => 5
      4.times {Factory.create :planet, :credits => 100, :sector => 1 }
      4.times {Factory.create :planet, :credits => 100, :sector => 2 }
      4.times {Factory.create :planet, :credits => 100, :sector => 3 }
      4.times {Factory.create :planet, :credits => 100, :sector => 4 }
      @round.new_game!
    end

    it 'should get a random planet for the squad' do
      rebel.planets(true).should_not be_empty
    end
    it 'should create 2 wormholes' do
      wormholes = Planet.where(:wormhole => true).all
      wormholes.count.should == 4
    end
    it 'should place a facility on the new planet' do
      rebel.facility_fleets(true).should_not be_empty
    end
    it 'should place facilities with initial balance' do
      rebel.facility_fleets(true).first.balance.should_not == 0
    end
    it 'should place random units on the planets' do
      rebel.generic_fleets.count.should == 21
    end
    it 'should randomize 4 planets with increased income' do
      Planet.where(:credits => @settings.bonus_planet_income).count.should == 4
    end

    it 'should set squad ready' do
      rebel.ready!
      rebel.ready.should be_true
    end

    it 'should change phases when all squads set ready' do
      Squad.where(:id => rebel.id).first.ready!
      Squad.where(:id => empire.id).first.ready!
      Round.getInstance.attack.should be_true
      Squad.where(:ready => true).should be_empty

      Squad.where(:id => rebel.id).first.ready!
      Squad.where(:id => empire.id).first.ready!
      Round.getInstance.number.should == 2
      Round.getInstance.move.should be_true
    end
    it 'should unload all carrier ships when passing moving phase' do
      carrier = Fleet.first
      carried_unit = Fleet.last
      carried_unit.carried_by = carrier
      carried_unit.save
      rebel.ready!
      empire.ready!
      @round.end_moving!
      Fleet.where(:carried_by => carrier).should be_empty
    end
    it 'should unflag sabotaged facilities when passing moving phase' do
      test_facility = FacilityFleet.first
      test_facility.sabotage!
      test_facility.sabotaged.should be_true
      rebel.ready!
      empire.ready!
      @round.end_moving!
      FacilityFleet.where(:sabotaged => true).count.should == 0
    end
    it 'should unflag sabotaged sensor when passing moving phase' do
      test_sensor = Fleet.last
      test_sensor.generic_unit = Factory(:sensor)
      test_sensor.save
      test_sensor.sabotage!
      test_sensor.sabotaged.should be_true
      rebel.ready!
      empire.ready!
      @round.end_moving!
      Fleet.where(:sabotaged => true).count.should == 0
    end
    it 'should not reassembly facility in enemy planet' do
      facility_fleet = FacilityFleet.where(:squad => Squad.last).first
      facility_fleet.moving = true
      facility_fleet.planet = Planet.where(:squad => Squad.first).first
      facility_fleet.save
      @round.end_round!
      facility_fleet.moving.should be_true
      facility_fleet = FacilityFleet.where(:squad => Squad.last).first
      facility_fleet.planet = Planet.where(:squad => Squad.last).first
      facility_fleet.save
      @round.end_round!
      facility_fleet.moving.should_not be_true
    end
    it 'should setup battles when 2 squads are in a planet' do
      warrior = Factory(:warrior)
      planet = Factory(:planet)
      warrior_fleet = Factory(:fleet, :generic_unit => warrior, :planet => planet, :quantity => 1)
      enemy_fleet = Factory(:generic_fleet, :generic_unit => Factory(:trooper), :planet => planet)
      @round.end_moving!
      Result.all.count.should > 0
    end
    it 'should transfer facilities balance to planet balance' do
      planet = Factory(:planet, :balance => 0)
      facility_fleet = Factory :facility, :planet => planet
      facility_fleet2 = Factory :facility, :planet => planet
      @round.end_round!
      planet.balance.should == 2000      
    end
  end
end

