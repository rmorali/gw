require 'spec_helper'

describe Tradeport do
  it {should belong_to :generic_unit}
  it {should belong_to :squad}
  it {should belong_to :planet}

  let(:tradeport) {Factory :tradeport}

  context 'acting like a trade station' do
    before do
      3.times {Factory.create :planet, :tradeport => true}
      3.times {Factory.create :capital_ship}
      3.times {Armament.create(:name => 'Missile', :acronym => 'M', :price => 10, :hyperdrive => false ).factions = ["mercenary"]}
      Tradeport.start
    end

    it 'should have a negotiation rate' do
      Tradeport.first.negotiation_rate.should_not be_nil
    end

    it 'should have units on stock' do
      Tradeport.count.should be 6
    end

    it 'should show negotiation rate' do
      Tradeport.first.show_negotiation_rate
    end

    it 'should change negotiation rate of units in stock to 100' do
      squad = Factory(:squad, :credits => 1000)
      unit = Factory(:generic_unit, :price => 500)
      planet = Factory(:planet)
      fleet = Factory(:generic_fleet, :squad => squad, :generic_unit => unit, :quantity => 1, :planet => planet)    
      Tradeport.buy_unit fleet, 1
      stock_item = Tradeport.where(:generic_unit => unit).first
      stock_item.negotiation_rate.should == 50
      Tradeport.start
      stock_item = Tradeport.where(:generic_unit => unit).first
      stock_item.negotiation_rate.should_not < 100
    end

  end


  context 'buying units' do
    before do
      @squad = Factory(:squad, :credits => 1000)
      unit = Factory(:generic_unit, :price => 500)
      planet = Factory(:planet)
      @fleet = Factory(:generic_fleet, :squad => @squad, :generic_unit => unit, :planet => planet, :quantity => 1)    
      Tradeport.buy_unit @fleet, 1
    end

    it 'should remove unit from squad fleet' do
      @squad.generic_fleets.count.should be 0
    end

    it 'should add unit to stock' do
      Tradeport.all.count.should be 1
    end

    it 'should pay credits to squad' do
      @squad.credits.should == 1000 + @fleet.generic_unit.price * 0.50
    end

  end

  context 'selling units' do
    before do
      @squad = Factory(:squad, :credits => 1000)
      planet = Factory(:planet)
      unit = Factory(:generic_unit, :price => 500)
      @unit = Factory(:tradeport, :generic_unit => unit, :negotiation_rate => 90)
      @unit.sell_unit planet, @squad, 1
    end

    it 'should add unit to squad fleet' do
      @squad.generic_fleets.count.should be 1
    end

    it 'should remove unit from stock' do
      Tradeport.all.count.should be 0
    end

    it 'should debit credits from squad' do
      @squad.credits.should == (@squad.credits - @unit.generic_unit.price * (@unit.negotiation_rate / 100)).to_i
    end

  end
 
end
