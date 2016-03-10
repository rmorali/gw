require 'spec_helper'

describe Miner do
  it 'should be a miner' do
    miner = Factory :miner
    miner.should be_a Miner
  end
end
