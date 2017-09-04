class GenericFleetsController < ApplicationController
  def index
    @planets = Planet.seen_by(current_squad)
    @round = Round.getInstance
    @squad = current_squad
    @all_squads = Squad.all
    @inactive = FacilityFleet.select { |facility| facility.squad == current_squad && facility.balance > 0 }
    @inactive_count = @inactive.count
    if @round.move?
      @round_phase = 'Estrategia'
      @tip = "Realize movimentos, configuracao de fabricas, compra/venda de naves e nomeacao de capital ships."
    else
      @round_phase = 'Combates'
      @tip = "Informe os resultados dos combates."
    end
    @small_fleet = nil
    total = 0
    redirect_to :controller => 'planets', :action => 'map'
  end

  def move
    @round = Round.getInstance
    @fleets = params[:fleets]
    @fleets.each do |id, attributes|
      @fleet = GenericFleet.find(id)
      unless attributes[:quantity].empty? || attributes[:destination_id].empty?
        @fleet.move attributes[:quantity].to_i, Planet.find(attributes[:destination_id].to_i) unless current_squad.ready? || @round.attack? || attributes[:destination_id].empty? || @fleet.type?(Facility)
        @fleet.move Planet.find(attributes[:destination_id].to_i) unless current_squad.ready? || @round.attack? || attributes[:destination_id].empty? || !@fleet.type?(Facility)
      else
        @fleet.move 1, nil unless current_squad.ready? || @round.attack? || @fleet.type?(Facility)
        @fleet.move nil unless current_squad.ready? || @round.attack? || !@fleet.type?(Facility)
      end
    end
  @planet = @fleet.planet
  #GroupFleet.new(@planet)
  redirect_to :controller => 'planets', :action => 'show', :id => @planet.id
  end

  def move_facility
    @round = Round.getInstance
    @facility = FacilityFleet.find(params[:facility_fleet][:id])
    unless params[:facility_fleet][:destination].empty?
      @planet = Planet.find(params[:facility_fleet][:destination])
      @facility.move @planet unless current_squad.ready? || @round.attack?
    else
      @planet = nil
      @facility.move @planet unless current_squad.ready? || @round.attack?
    end
    redirect_to :back
  end

  def back_to_main
    redirect_to :fleets
  end

end
