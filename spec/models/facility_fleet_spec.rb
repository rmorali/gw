require 'spec_helper'

describe FacilityFleet do
  it {should belong_to :producing_unit}
  it {should belong_to :producing_unit2}
  it {should belong_to :destination}
  let(:facility_fleet) {Factory :facility_fleet}
  let(:facility) {facility_fleet.facility}
  let(:unit) {Factory :unit}
  let(:squad) {Factory :squad}
  let(:planet) {Factory :planet}

  it 'should be a fleet' do
    facility_fleet.should be_an_instance_of FacilityFleet
    facility_fleet.should be_a_kind_of GenericFleet
  end

  it 'should have a facility balance' do
    facility_fleet.balance = 1000
    facility_fleet.balance.should == 1000
  end

  it 'should start with level 0' do
    facility_fleet.level = 0
    facility_fleet.save
    facility_fleet.level.should be 0
  end
  it 'should increase level' do
      2.times {facility_fleet.upgrade!}
      facility_fleet.level.should == 2   
  end
  
  it 'should flag as sabotaged' do
    facility_fleet.sabotage!
    facility_fleet.sabotaged.should be_true
  end

  context 'moving' do
    before do
      facility_fleet.squad = squad
      facility_fleet.balance = 1000
      facility_fleet.level = 1
      facility_fleet.save
      @moving_fleet = facility_fleet.move planet
    end

    context 'setting to move' do
      it 'should be flagged as a moving unit when moving' do
        @moving_fleet.should be_moving
      end
      it 'should have a destination planet when moving' do
        @moving_fleet.destination.should == planet
      end
      it 'should change display name when moving' do
        @moving_fleet.name.should_not == facility_fleet.facility.name
        @moving_fleet.name.should == facility_fleet.facility.description
      end
    end

    context 'finishing movement' do
      before(:each) do
        @moving_fleet.move!
      end
      it 'should effect moving orders' do
        @moving_fleet.should be_moving
        @moving_fleet.destination.should == planet
        @moving_fleet.planet.should == planet
      end
      it 'should be unflagged as a moving unit' do
        @moving_fleet.reassembly
        @moving_fleet.should_not be_moving
      end
      it 'should keeps its balance and level' do
        @moving_fleet.reassembly
        @moving_fleet.balance.should == 1000
        @moving_fleet.level.should == 1
      end
    end

  end

  context 'related to fleeing fleet' do
    let(:unit) {Factory :facility_fleet, :squad => squad}
    before(:each) do
      @origin = Factory(:planet)
      @destination = Factory(:planet)
      unit.planet = @origin
      @route1 = Factory :route, :vector_a => @origin, :vector_b => @destination
    end

    it 'should go to an adjacent planet' do
      fleeing_fleet = unit.flee! 1
      fleeing_fleet.planet.should_not == @origin
      fleeing_fleet.planet.should == @destination
    end

  end
    
  context 'on every new turn' do
    let(:facility) {facility_fleet.facility}
    before(:each) do
      @settings = Setting.getInstance
      facility_fleet.planet = Factory :planet
      facility_fleet.level = 0
      facility_fleet.save!
    end
    it 'should set its balance on every new turn' do
      facility_fleet.update_balance!
      facility_fleet.balance.should == facility.capacity
    end
    it 'should set its balance 50% less when sabotaged or blocked' do
      facility_fleet.producing_unit = nil
      facility_fleet.save
      facility_fleet.sabotage!
      facility_fleet.update_balance!
      facility_fleet.balance.should == facility.capacity * 0.50
    end
    it 'should not update its balance if moving' do
      facility_fleet.moving = true
      facility_fleet.balance = 0
      facility_fleet.save
      facility_fleet.update_balance!
      facility_fleet.balance.should == 0
    end
    it 'should block its function after being captured' do

    end
  end

  context 'producing units' do
    let(:facility) {facility_fleet.facility}
    before(:each) do
      @settings = Setting.getInstance
      facility_fleet.planet = Factory :planet
      facility_fleet.level = 0
      facility_fleet.balance = 1000
      facility_fleet.save!
    end
    it 'should produce fleet if we have enough production points' do
      facility_fleet.produce! unit, 1, planet, squad
      Fleet.count.should be 1
    end
    it 'should not produce a fleet if we dont have production points' do
      facility_fleet.balance = 0
      facility_fleet.save
      facility_fleet.produce! unit, 1, planet, squad
      Fleet.count.should_not > 0
    end

    it 'should debit squad credits for upgrade' do
      squad = Factory(:squad, :credits => 10000)
      upgrade_costs = @settings.facility_upgrade_cost
      facility_fleet.squad = squad
      facility_fleet.save!
      facility_fleet.upgrade!
      squad.credits.should == 10000 - upgrade_costs
    end
    it 'should save the round of construction in a new unit' do
      @round = Round.getInstance
      facility_fleet.produce! unit, 1, planet, squad
      Fleet.first.round.should_not be_nil
    end
    it 'should set a level in a new unit' do
      facility_fleet.produce! unit, 1, planet, squad
      Fleet.first.level.should_not be_nil
    end
  end

end
