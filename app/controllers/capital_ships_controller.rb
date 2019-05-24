class CapitalShipsController < ApplicationController

  def edit
    @capital_ship = GenericFleet.find(params[:id])
    @planet = @capital_ship.planet
    GroupFleet.new(@planet)
    @carriable_fleets = Fleet.select { |fleet| fleet.is_transportable? && fleet.planet == @capital_ship.planet && fleet.squad == @capital_ship.squad }
    @carried_fleets = GenericFleet.where(:carried_by => @capital_ship)
    @skills = Fleet.select{ |unit| unit.planet == @capital_ship.planet && unit.squad == @capital_ship.squad && unit.type?(Skill) && !unit.moving? }
    @squad = current_squad
  end

  def update
    @capital_ship = GenericFleet.find(params[:id])
    @capital_ship.change_fleet_name(params[:fleet][:fleet_name].squeeze(" ").strip)
    redirect_to :back
  end

  def load_in
    @fleet = GenericFleet.find(params[:fleet][:id])
    @capital_ship = GenericFleet.find(params[:id])
    @fleet.load_in @capital_ship, params[:fleet][:quantity].to_i if params[:fleet][:quantity] && @fleet.squad.ready != true
    GroupFleet.new(@fleet.planet).group!
    redirect_to :back
  end

  def unload_from
    @fleet = GenericFleet.find(params[:fleet][:id])
    @capital_ship = GenericFleet.find(params[:id])
    @fleet.unload_from @capital_ship, params[:fleet][:quantity].to_i if params[:fleet][:quantity] && @fleet.squad.ready != true
    GroupFleet.new(@fleet.planet).group!
    redirect_to :back
  end

  def install_skill
    @capital_ship = GenericFleet.find(params[:fleet][:id])
    unless @capital_ship.skill_id || !params[:fleet][:skill_id]
      @skill = GenericFleet.find(params[:fleet][:skill_id])
      @capital_ship.install @skill
    end
    GroupFleet.new(@capital_ship.planet).group!
    redirect_to :back
  end

  def uninstall_skill
    @capital_ship = GenericFleet.find(params[:fleet][:id])
    @capital_ship.uninstall_skill unless @capital_ship.skill_id == nil
    GroupFleet.new(@capital_ship.planet).group!
    redirect_to :back
  end

end
