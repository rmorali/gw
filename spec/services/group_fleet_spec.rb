require 'spec_helper'

describe GroupFleet do
  before(:each) do
    GenericFleet.destroy_all
    @planet = Factory :planet
    @squad = Factory :squad
    @unit = Factory :fighter
    @capital_ship = Factory :capital_ship
    @skill = Factory :skill
    @weapon = Factory :armament
    @fleet_a = Factory :generic_fleet,
                :generic_unit => @unit,
                :squad => @squad,
                :planet => @planet,
                :quantity => 2,
                :moving => nil,
                :destination => @planet,
                :carried_by => nil,
                :weapon1 => @weapon,
                :weapon2 => @weapon,
                :skill => @skill
    @fleet_b = GenericFleet.new(@fleet_a.attributes)
  end

  it 'only groups groupable fleets' do
    expect{GroupFleet.new(@planet).groupable?(@fleet_a)}.to be_true
    @fleet_a.update_attributes(:generic_unit => @capital_ship)
    expect{GroupFleet.new(@planet).groupable?(@fleet_a)}.not_to be_true
  end
  it 'groups by the right attributes' do
    expect(GroupFleet.new(@planet).grouped.count).to be 1
    @fleet_a.update_attributes(:moving => nil)
    expect(GroupFleet.new(@planet).grouped.count).not_to be 1
  end
  it 'destroy the equal fleets' do
    GroupFleet.new(@planet)
    expect(GenericFleet.count).to be 1
  end
  it 'updates the quantity of the first fleet' do

  end

end
