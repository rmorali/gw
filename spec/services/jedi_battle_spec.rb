require "spec_helper"

describe JediBattle do
  before do
    @planet = Factory :planet
    @round = Round.getInstance
  end

  context "with just a jedi and some enemy troops" do
    before do
      Result.destroy_all
      @warrior = Factory :result, :generic_unit => Factory(:warrior), :squad => Factory(:squad), :planet => @planet, :quantity => 10, :round => @round
      @enemy_trooper = Factory :result, :generic_unit => Factory(:trooper), :squad => Factory(:squad), :planet => @planet, :quantity => 10, :round => @round
      @battle = JediBattle.new(@planet)
    end

    it "takes at least 1 and some random shots at the warrior" do
      @battle.should_receive(:random_damage_to_warrior?).exactly(3).times.and_return(true)
      @battle.fight!
      @warrior.reload.blasted.should == 1 + 3
    end

    it 'flag as automatic result' do
      @battle.fight!
      @warrior.reload.automatic.should be_true
    end
  end

  context "with enemy jedis fighting" do
    before do
      @warrior = Factory :result, :generic_unit => Factory(:warrior), :squad => Factory(:squad), :planet => @planet, :quantity => 10, :round => @round
      @enemy_warrior = Factory :result, :generic_unit => Factory(:warrior), :squad => Factory(:squad), :planet => @planet, :quantity => 10, :round => @round
      @battle = JediBattle.new(@planet)
    end

    it "lefts one jedi alive" do
      @battle.should_receive(:random_damage_to_warrior?).exactly(17).times.and_return(true)
      @battle.fight!
      @enemy_warrior.reload.blasted.should == 9
    end
  end

  context "with three jedis, two squads" do
    before do
      @squad = Factory :squad
      @warrior = Factory :result, :generic_unit => Factory(:warrior), :squad => @squad, :planet => @planet, :quantity => 10, :round => @round
      @another_warrior = Factory :result, :generic_unit => Factory(:warrior), :squad => @squad, :planet => @planet, :quantity => 10, :round => @round
      @enemy_warrior = Factory :result, :generic_unit => Factory(:warrior), :squad => Factory(:squad), :planet => @planet, :quantity => 10, :round => @round
      @battle = JediBattle.new(@planet)
    end

    it "stops when there is only a squad left" do
      @battle.stub(:random_damage_to_warrior? => true)
      @battle.fight!
      @battle.only_one_squad_left?.should be_true
    end
  end
end
