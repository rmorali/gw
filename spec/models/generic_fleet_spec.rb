require 'spec_helper'

describe GenericFleet do

  it {should belong_to :squad}
  it {should belong_to :planet}
  it {should belong_to :generic_unit}
  it {should belong_to :destination}
  it {should belong_to :carried_by}
  it {should belong_to :weapon1}
  it {should belong_to :weapon2}
  it {should belong_to :skill}


  let(:unit) {Factory :generic_fleet}
  let(:trooper) {Factory :trooper}
  let(:capital_ship) {Factory :capital_ship}
  let(:light_transport) {Factory :light_transport}
  let(:fighter) {Factory :fighter}
  let(:armament) {Factory :armament}
  let(:skill) {Factory :skill}
  let(:facility_unit) {Factory :facility_fleet}
  let(:facility) {Factory :facility}
  let(:sensor) {Factory :sensor}
  let(:commander) {Factory :commander}
  let(:planet) {Factory :planet}

  context 'managing fleets' do
    before(:each) do
      GenericFleet.destroy_all
      unit.generic_unit = capital_ship
      unit.planet = planet
      unit.quantity = 1
      unit.save
    end
    it 'should give a fleet name' do
      unit.change_fleet_name 'Nomeada'
      unit.fleet_name.should == 'Nomeada'
    end
    it 'should verify unit type' do
      unit.type?(Trooper).should be_false
      unit.type?(CapitalShip).should be_true
    end
    it 'should show its unit name' do
      unit.name.should == capital_ship.name
    end
    it 'check if the unit is movable' do
      planet = Factory :planet, :sector => 1
      second_planet = Factory :planet, :sector => 1
      Factory :route, :vector_a => planet, :vector_b => second_planet
      unit.planet = planet
      unit.save
      unit.is_movable?.should be_true
      unit.generic_unit = trooper
      unit.save
      unit.is_movable?.should_not be_true
      unit.generic_unit = armament
      unit.save
      unit.is_movable?.should_not be_true
      unit.generic_unit = sensor
      unit.save
      unit.is_movable?.should_not be_true
      unit.generic_unit = skill
      unit.save
      unit.is_movable?.should_not be_true
      unit.generic_unit = commander
      unit.save
      unit.is_movable?.should_not be_true
      unit.generic_unit = fighter
      unit.save
      unit.is_movable?.should_not be_true
      @allied_fleet = Factory :generic_fleet, :planet => second_planet, :squad => unit.squad
      unit.is_movable?.should be_true
      unit.generic_unit.hyperdrive = false
      unit.generic_unit.save
      unit.is_movable?.should_not be_true
      @carrier = Factory :generic_fleet, :generic_unit => capital_ship, :planet => planet, :squad => unit.squad
      unit.carried_by = @carrier
      unit.generic_unit.hyperdrive = nil
      unit.save
      unit.is_movable?.should_not be_true
    end
    it 'should show posted results on dashboard' do
      result = Factory :result
      planet = Factory :planet
      round = Round.getInstance
      round.attack = true
      round.save
      result.planet = planet
      result.round = round
      result.blasted = 1
      result.fled = 1
      result.captured = 1
      result.captor = Factory :squad
      result.sabotaged = true
      result.generic_fleet = unit
      result.save!
      unit.show_results.should == '1d 1f 1c sabot'
    end
    it 'should be destroyed if empty' do
      GenericFleet.all.should_not be_empty
      unit.quantity -= 1
      unit.save
      GenericFleet.all.should be_empty
    end
    it 'should check the loading capacity' do
      unit.generic_unit = capital_ship
      unit.save
      unit.heavy_loading_capacity.should == unit.generic_unit.heavy_loading_capacity * unit.quantity
      unit.light_loading_capacity.should == unit.generic_unit.light_loading_capacity * unit.quantity
    end
    it 'should check if the unit is transportable' do
      unit.generic_unit = trooper
      unit.quantity = 1
      unit.save
      unit.is_transportable?.should be_true
      carrier = Factory(:generic_fleet, :generic_unit => capital_ship, :quantity => 1)
      unit.carried_by = carrier
      unit.save
      unit.is_transportable?.should_not be_true
    end
    it 'should check if the unit is a builder' do
      settings = Setting.getInstance
      settings.builder_unit = 'LightTransport'
      settings.save
      unit.is_a_builder?.should_not be_true
      unit.generic_unit = light_transport
      unit.save
      unit.is_a_builder?.should be_true
    end
    it 'should be loaded into a carrier ship' do
      planet = Factory :planet
      carrier = Factory(:generic_fleet, :generic_unit => capital_ship, :quantity => 1, :planet => planet)
      unit.load_in carrier, 1
      unit.carrier.should be carrier
      carrier.cargo.first.should == unit
    end
    it 'should be partially loaded into a carrier ship' do
      carrier = Factory(:generic_fleet, :generic_unit => capital_ship, :quantity => 1)
      unit.quantity = 10
      unit.save
      unit.load_in carrier, 6
      carrier.cargo.first.should == unit
      carrier.cargo.first.quantity.should == 6
      not_loaded_fleet = GenericFleet.where(:quantity => 4).first
      not_loaded_fleet.quantity.should == 4
    end
    it 'should limit the quantity of light units carried' do
      planet = Factory :planet
      carrier = Factory(:generic_fleet, :generic_unit => light_transport, :planet => planet, :quantity => 2)
      unit.generic_unit = trooper
      unit.quantity = 300
      unit.planet = planet
      unit.save
      unit.load_in carrier, 300
      carrier.cargo.first.should == unit
      carrier.cargo.first.quantity.should == carrier.light_loading_capacity
    end
    it 'should limit the quantity of heavy units carried' do
      planet = Factory :planet
      carrier = Factory(:generic_fleet, :generic_unit => light_transport, :planet => planet, :quantity => 2)
      unit.generic_unit = fighter
      unit.quantity = 100
      unit.planet = planet
      unit.save
      unit.load_in carrier, 100
      carrier.cargo.first.should == unit
      carrier.cargo.first.quantity.should == carrier.heavy_loading_capacity
    end
    it 'should reset moving status when loaded into a carrier' do
      carrier = Factory(:generic_fleet, :generic_unit => capital_ship, :quantity => 1)
      planet = Factory :planet
      unit.quantity = 10
      unit.moving = true
      unit.destination = planet
      unit.save
      unit.load_in carrier, 6
      carrier.cargo.first.should == unit
      carrier.cargo.first.quantity.should == 6
      carrier.cargo.first.should_not be_moving
      carrier.cargo.first.destination.should be_nil
      not_loaded_fleet = GenericFleet.where(:quantity => 4).first
      not_loaded_fleet.quantity.should == 4
      not_loaded_fleet.should be_moving
      not_loaded_fleet.destination.should == planet       
    end
    it 'should be unloaded from a carrier ship' do
      carrier = Factory(:generic_fleet, :generic_unit => capital_ship, :quantity => 1)
      unit.load_in carrier, 1
      unit.carrier.should be carrier
      unit.unload_from carrier, 1
      unit.carrier.should be_nil
    end
    it 'should be partially unloaded from a carrier ship' do
      carrier = Factory(:generic_fleet, :generic_unit => capital_ship, :quantity => 1)
      unit.quantity = 10
      unit.save
      unit.load_in carrier, 10
      unit.carrier.should be carrier
      unit.unload_from carrier, 6
      carrier.cargo.first.should == unit
      carrier.cargo.first.quantity.should == 4
      unloaded_fleet = GenericFleet.where(:quantity => 6).first
      unloaded_fleet.quantity.should == 6
    end
    it 'should reset moving status when unloaded from a carrier' do
      carrier = Factory(:generic_fleet, :generic_unit => capital_ship, :quantity => 1)
      planet = Factory :planet
      carrier.moving = true
      carrier.destination = planet
      carrier.save
      unit.quantity = 10
      unit.save 
      unit.load_in carrier, 10
      unit.carrier.should be carrier
      unit.should be_moving
      unit.destination.should == planet
      unit.unload_from carrier, 6
      carrier.cargo.first.should == unit
      carrier.cargo.first.quantity.should == 4
      carrier.cargo.first.should be_moving
      carrier.cargo.first.destination.should == planet
      unloaded_fleet = GenericFleet.where(:quantity => 6).first
      unloaded_fleet.quantity.should == 6
      unloaded_fleet.should_not be_moving
      unloaded_fleet.destination.should be_nil
    end
    it 'should arm a fleet' do
      armament_fleet = Factory(:generic_fleet, :generic_unit => armament, :quantity => 10)
      unit.generic_unit = Factory :fighter
      unit.quantity = 10
      unit.save
      unit.arm_with armament_fleet
      unit.weapon1.should == armament
      unit.quantity.should == 10
      GenericFleet.count.should == 1   
    end
    it 'should partially arm a fleet' do
      armament_fleet = Factory(:generic_fleet, :generic_unit => armament, :quantity => 4)
      unit.generic_unit = Factory :fighter
      unit.quantity = 10
      unit.save
      unit.arm_with armament_fleet
      unit.weapon1.should == armament
      unit.quantity.should == 4
      not_armed_unit = GenericFleet.where(:weapon1_id => nil).first
      not_armed_unit.quantity.should == 6
      GenericFleet.count.should == 2
    end
    it 'should arm a fleet and leave some armament' do
      armament_fleet = Factory(:generic_fleet, :generic_unit => armament, :quantity => 10)
      unit.generic_unit = Factory :fighter
      unit.quantity = 4
      unit.save
      unit.arm_with armament_fleet
      unit.weapon1.should == armament
      unit.quantity.should == 4
      armament_fleet.quantity.should == 6
      GenericFleet.count.should == 2
    end

    it 'should disarm a fleet' do
      unit.generic_unit = Factory :fighter
      unit.planet = Factory :planet
      unit.quantity = 10
      unit.weapon1 = armament
      unit.weapon1 = armament
      unit.save
      unit.weapon1.should == armament
      unit.disarm
      unit.weapon1.should be_nil
      unit.weapon2.should be_nil
      armament_fleet = GenericFleet.where(:generic_unit => armament).first
      armament_fleet.quantity.should == 10      
    end

    it 'should install skill in a fleet' do
      skill_fleet = Factory(:generic_fleet, :generic_unit => skill, :quantity => 10)
      unit.generic_unit = Factory :capital_ship
      unit.quantity = 10
      unit.save
      unit.install skill_fleet
      unit.skill.should == skill
      unit.quantity.should == 10
      GenericFleet.count.should == 1   
    end
    it 'should partially install skill in a fleet' do
      skill_fleet = Factory(:generic_fleet, :generic_unit => skill, :quantity => 4)
      unit.generic_unit = Factory :capital_ship
      unit.quantity = 10
      unit.save
      unit.install skill_fleet
      unit.skill.should == skill
      unit.quantity.should == 4
      not_skilled_unit = GenericFleet.where(:skill_id => nil).first
      not_skilled_unit.quantity.should == 6
      GenericFleet.count.should == 2
    end
    it 'should install skill in a fleet and leave spare skills' do
      skill_fleet = Factory(:generic_fleet, :generic_unit => skill, :quantity => 10)
      unit.generic_unit = Factory :capital_ship
      unit.quantity = 4
      unit.save
      unit.install skill_fleet
      unit.skill.should == skill
      unit.quantity.should == 4
      skill_fleet.quantity.should == 6
      GenericFleet.count.should == 2
    end
    it 'should uninstall skills from a fleet' do
      unit.generic_unit = Factory :capital_ship
      unit.planet = Factory :planet
      unit.quantity = 10
      unit.skill = skill
      unit.save
      unit.skill.should == skill
      unit.uninstall_skill
      unit.skill.should be_nil
      skill_fleet = GenericFleet.where(:generic_unit => skill).first
      skill_fleet.quantity.should == 10      
    end
    it 'should cancel movement if a Long Range Engine is uninstalled' do
      skill.acronym = 'ENG'
      skill.save
      skill_fleet = Factory(:generic_fleet, :generic_unit => skill, :quantity => 1)
      unit.moving = true
      unit.destination = planet
      unit.save 
      unit.moving.should be_true
      unit.destination.should == planet
      unit.install skill_fleet
      unit.skill.should == skill
      unit.uninstall_skill
      unit.skill.should be_nil
      unit.moving.should be_nil
      #unit.destination.should_not == planet
    end

  end

  context 'blast units' do
    before(:each) do
      unit.quantity = 1
    end
    it 'should remove units from the current fleet' do
      unit.blast! 1
      unit.quantity.should be 0
    end
  end

  context 'capturing units' do
    let(:squad) {Factory :squad}
    before(:each) do
      unit.quantity = 1
    end
    it 'should remove units from the current fleet' do
      unit.capture! 1, squad
      unit.quantity.should be 0
    end
    it 'should remove fleet if quantity equals zero' do
      unit.capture! 1, squad
      unit.should be_new_record
    end
    it 'should transfer fleet to another squad' do
      unit.capture! 1, squad
      squad.generic_fleets.count.should be 1
    end

    context 'related to captured fleet' do
      before(:each) do
        unit.capture! 1, squad
      end
      let(:captured_unit) {squad.generic_fleets.first}
      it 'should have the captured quantity' do
        captured_unit.quantity.should be 1
      end
    end

    context 'related to captured facility fleet' do
      it 'should keeps its balance when captured' do
        facility_unit.planet = planet
        facility_unit.balance = 100
        facility_unit.producing_unit = capital_ship
        facility_unit.save
        facility_unit.capture! 1,squad
        captured_facility = squad.generic_fleets.first
        captured_facility.update_balance!
        captured_facility = squad.generic_fleets.first
        captured_facility.balance.should == 100
      end
    end

  end

  context 'sabotaging units' do
    before(:each) do
      unit.quantity = 1
    end
    it 'should remove flag unit as sabotaged' do
      unit.sabotage!
      unit.sabotaged.should be_true
    end
  end

  context 'regarding to skills' do
    before(:each) do
      sar = Factory :skill, :acronym => 'SAR'
      @sensor_skill = Factory :generic_fleet, :generic_unit => sar
      eng = Factory :skill, :acronym => 'ENG'
      @engine_skill = Factory :generic_fleet, :generic_unit => eng
      atb = Factory :skill, :acronym => 'ATB'
      @anti_trooper_bomb_skill = Factory :generic_fleet, :generic_unit => atb
      @capital_ship = Factory :generic_fleet, :generic_unit => capital_ship
    end
    it 'should test the sensor array skill SAR' do
      @capital_ship.is_a_sensor?.should_not be_true
      @capital_ship.install @sensor_skill
      @capital_ship.is_a_sensor?.should be_true
    end
    it 'should test the anti-trooper bombs skill ATB' do
      @capital_ship.is_a_bomber?.should_not be_true
      @capital_ship.install @anti_trooper_bomb_skill
      @capital_ship.is_a_bomber?.should be_true
    end

  end


end

