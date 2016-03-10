require "spec_helper"

describe TrooperBattle do
  before do
    @planet = Factory :planet
    @round = Round.getInstance
  end

  context "with enemy troopers fighting" do
    before do
      @trooper = Factory :result, :generic_unit => Factory(:trooper), :squad => Factory(:squad), :planet => @planet, :quantity => 10, :round => @round
      @enemy_trooper = Factory :result, :generic_unit => Factory(:trooper), :squad => Factory(:squad), :planet => @planet, :quantity => 10, :round => @round
      @battle = TrooperBattle.new(@planet)
    end

    it "lefts one trooper" do
      @battle.should_receive(:random_damage_to_trooper?).exactly(19).times.and_return(true)
      @battle.fight!
      @enemy_trooper.reload.blasted.should == 9
    end
    it 'flag as automatic result' do
      @battle.fight!
      @enemy_trooper.reload.automatic.should be_true
    end
  end

  context "with three squads" do
    before do
      @squad = Factory :squad
      @warrior = Factory :result, :generic_unit => Factory(:trooper), :squad => @squad, :planet => @planet, :quantity => 10, :round => @round
      @another_warrior = Factory :result, :generic_unit => Factory(:trooper), :squad => @squad, :planet => @planet, :quantity => 10, :round => @round
      @enemy_warrior = Factory :result, :generic_unit => Factory(:trooper), :squad => Factory(:squad), :planet => @planet, :quantity => 10, :round => @round
      @battle = TrooperBattle.new(@planet)
    end

    it "stops when there is only a squad left" do
      @battle.stub(:random_damage_to_trooper? => true)
      @battle.fight!
      @battle.only_one_squad_left?.should be_true
    end
  end

  context "with enemy bombers" do
    before do
      @trooper = Factory :result, :generic_unit => Factory(:trooper), :squad => Factory(:squad), :planet => @planet, :quantity => 5, :round => @round
      @enemy_bomber = Factory :result, :generic_unit => Factory(:capital_ship), :squad => Factory(:squad), :planet => @planet, :quantity => 1, :round => @round, :skill => Factory(:skill, :acronym => 'ATB')
      @battle = TrooperBattle.new(@planet)
    end

    it "bomb only if there are more than 10 troopers" do
      @battle.fight!
      @trooper.reload.blasted.should be_nil
    end

    it "bomb and destroy up to 50% of enemy troopers" do
      @trooper.quantity = 20
      @trooper.save
      @battle.fight!
      @trooper.reload.blasted.should_not be_nil
    end

    it "bomb only if the bomber was not disabled" do
      @trooper.quantity = 20
      @trooper.save
      @enemy_bomber.blasted = 1
      @enemy_bomber.save
      @battle.fight!
      @trooper.reload.blasted.should be_nil
    end
  end

  context "with partial results already taken" do
    before(:each) do
      @trooper = Factory :result, :generic_unit => Factory(:trooper), :squad => Factory(:squad), :planet => @planet, :quantity => 10, :round => @round
      @enemy_trooper = Factory :result, :generic_unit => Factory(:trooper), :squad => Factory(:squad), :planet => @planet, :quantity => 10, :round => @round
      @battle = TrooperBattle.new(@planet)
    end
    it 'should avoid troopers that have been fled' do
      @trooper.fled = 9
      @trooper.save
      @battle.fight!
      @trooper.reload.blasted.should_not > 1
    end
    it 'should avoid troopers that have not been landed' do
      @trooper.not_landed = 9
      @trooper.save
      @battle.fight!
      @trooper.reload.blasted.should_not > 1
    end
  end

end
