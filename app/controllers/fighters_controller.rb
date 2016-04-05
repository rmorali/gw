class FightersController < ApplicationController

  def edit
    @fighter = GenericFleet.find(params[:id])
    @planet = @fighter.planet
    @armaments = Fleet.select{ |unit| unit.planet == @fighter.planet && unit.squad == @fighter.squad && unit.type?(Armament) && !unit.moving? && !unit.carried_by_id }
  end

  def arm_1
    @fighter = GenericFleet.find(params[:fleet][:id])
    unless @fighter.weapon1_id || !params[:fleet][:weapon1_id]
      @armament = GenericFleet.find(params[:fleet][:weapon1_id]) 
      @fighter.arm_with @armament, 1
    end
    redirect_to :back
  end

  def arm_2
    @fighter = GenericFleet.find(params[:fleet][:id])
    unless @fighter.weapon2_id || !params[:fleet][:weapon2_id]
      @armament = GenericFleet.find(params[:fleet][:weapon2_id]) 
      @fighter.arm_with @armament, 2
    end
    redirect_to :back
  end

  def disarm_1
    @fighter = GenericFleet.find(params[:fleet][:id])
    @fighter.disarm 1 unless @fighter.weapon1_id == nil
    redirect_to :back
  end

  def disarm_2
    @fighter = GenericFleet.find(params[:fleet][:id])
    @fighter.disarm 2 unless @fighter.weapon2_id == nil
    redirect_to :back
  end

end
