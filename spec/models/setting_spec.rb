require 'spec_helper'

describe Setting do

  it {should validate_numericality_of :initial_factories}
  it {should validate_numericality_of :initial_capital_ships}
  it {should validate_numericality_of :initial_fighters}
  it {should validate_numericality_of :initial_transports}
  it {should validate_numericality_of :initial_troopers}
  it {should validate_numericality_of :initial_planets}
  it {should validate_numericality_of :initial_credits}
  it {should validate_numericality_of :net_planet_income}
  it {should validate_numericality_of :bonus_planet_income}
  it {should validate_numericality_of :facility_divisor_rate}
  it {should validate_numericality_of :facility_upgrade_cost}
  it {should validate_numericality_of :capital_ship_upgrade_cost}
  it {should validate_numericality_of :maximum_warrior_life}
  it {should validate_numericality_of :maximum_fleet_size}
  it {should validate_numericality_of :presence_to_influence}
  it {should validate_numericality_of :rounds_to_dominate}

  context 'setting up a game' do
    before do
      Factory :setting
    end

    it 'should get the game settings' do
      settings = Setting.getInstance
      settings.should be_present
    end

    it 'should apply changes in income' do
      planet_a = Factory :planet
      planet_b = Factory :planet, :special => true
      config = Factory :setting
      config.net_planet_income = 2000
      config.bonus_planet_income = 5000
      config.save
      planet_a.reload
      planet_a.credits.should == 2000
      planet_b.reload
      planet_b.credits.should == 5000

    end

  end



end
