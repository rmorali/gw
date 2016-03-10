require 'spec_helper'

describe Warrior do
  before do
    @warrior = Factory :warrior
  end
  it 'should be a warrior' do
    @warrior.should be_a Warrior
  end
  it 'should get max lives' do
    @warrior.maximum_lives.should == Setting.getInstance.maximum_warrior_life
  end
end
