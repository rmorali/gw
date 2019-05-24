class FleetsController < ApplicationController

  def move_one_fleet
    @round = Round.getInstance
    @fleet = GenericFleet.find(params[:id])
    unless params[:fleet][:quantity].empty? || params[:fleet][:destination].empty?
      @destination = Planet.find(params[:fleet][:destination]) 
      @fleet.move params[:fleet][:quantity].to_i, @destination unless current_squad.ready? || @round.attack? || @destination.nil? || @fleet.type?(Facility)
    else
      @fleet.move 1, nil unless current_squad.ready? || @round.attack? || @fleet.type?(Facility)
      @fleet.move nil unless current_squad.ready? || @round.attack? || !@fleet.type?(Facility)
    end
    GroupFleet.new(@fleet.planet).group!
    #redirect_to :controller => 'planets', :action => 'index', :id => @planet.id
  redirect_to :back
  end

  def arm
    @unit = GenericFleet.find(params[:fleet][:id])
    unless @unit.weapon1_id || !params[:fleet][:weapon1_id]
      @armament = GenericFleet.find(params[:fleet][:weapon1_id]) 
      @unit.arm_with @armament, 1
    end
    GroupFleet.new(@unit.planet).group!
    redirect_to :back
  end

  def disarm
    @unit = GenericFleet.find(params[:fleet][:id])
    @unit.disarm 1 unless @unit.weapon1_id == nil
    GroupFleet.new(@unit.planet).group!
    redirect_to :back
  end


  def back_to_main
    redirect_to :fleets
  end

end
