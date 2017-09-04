require 'spec_helper'

describe GroupFleet do
  before(:each) do
    @planet = Factory :planet
    @squad = Factory :squad
    @fighter = Factory :fighter
    @capital_ship = Factory :capital_ship
    @facility = Factory :facility
    @skill = Factory :skill
    @weapon = Factory :armament
    2.times do
      Factory :generic_fleet,
              generic_unit: @fighter,
              squad: @squad,
              planet: @planet,
              quantity: 2,
              moving: nil,
              destination: @planet,
              carried_by: nil,
              weapon1: @weapon,
              weapon2: @weapon,
              skill: @skill
    end
  end
  it 'groups identical fleets' do
    expect(GenericFleet.all).to_not have(1).fleet
    GroupFleet.new(@planet).group!
    expect(GenericFleet.all).to have(1).fleet
  end
  it 'updates the quantity of the grouped fleet' do
    GroupFleet.new(@planet).group!
    expect(GenericFleet.first.quantity).to be 4
  end
  it 'do not group capital ships or facilities' do
    GenericFleet.first.update_attributes(generic_unit: @capital_ship)
    GroupFleet.new(@planet).group!
    expect(GenericFleet.all).to_not have(1).fleet
    GenericFleet.first.update_attributes(generic_unit: @facility)
    GroupFleet.new(@planet).group!
    expect(GenericFleet.all).to_not have(1).fleet
  end
end
