class LightTransportsController < ApplicationController

  def edit
    @squad = current_squad
    @light_transport = GenericFleet.find(params[:id])
    @planet = @light_transport.planet
    GroupFleet.new(@planet)
    @carriable_fleets = Fleet.where(:planet => @light_transport.planet, :squad => @light_transport.squad, :carried_by_id => nil).reject! { |fleet| fleet == @light_transport || fleet.type?(LightTransport) || fleet.type?(CapitalShip) || fleet.type?(Sensor) || fleet.moving? }
    @carried_fleets = GenericFleet.where(:carried_by => @light_transport)
    @armaments = Fleet.select{ |unit| unit.planet == @light_transport.planet && unit.squad == @light_transport.squad && unit.type?(Armament) && !unit.moving? && !unit.carried_by_id }
  end

  def load_in
    @fleet = GenericFleet.find(params[:fleet][:id])
    @light_transport = GenericFleet.find(params[:id])
    @fleet.load_in @light_transport, params[:fleet][:quantity].to_i if params[:fleet][:quantity]
    GroupFleet.new(@fleet.planet).group!
    redirect_to :back
  end

  def unload_from
    @fleet = GenericFleet.find(params[:fleet][:id])
    @light_transport = GenericFleet.find(params[:id])
    @fleet.unload_from @light_transport, params[:fleet][:quantity].to_i if params[:fleet][:quantity]
    GroupFleet.new(@fleet.planet).group!
    redirect_to :back
  end

end
