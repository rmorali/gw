class FightersController < ApplicationController

  def edit
    @fighter = GenericFleet.find(params[:id])
    @planet = @fighter.planet
    @armaments = Fleet.select{ |unit| unit.planet == @fighter.planet && unit.squad == @fighter.squad && unit.type?(Armament) && !unit.moving? && !unit.carried_by_id }
    @squad = current_squad
  end

end
