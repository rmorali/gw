class PlanetsController < ApplicationController

  before_filter :authenticate_user!, :except => [:map]

  respond_to :html, :xml, :json

  def index
    @round = Round.getInstance
    @setting = Setting.getInstance
    @current_squad = current_squad
    @squad = current_squad
    @map_ratio = ( @current_squad.map_ratio.to_f / 100 ).to_f
    @planets = Planet.includes(:squad).all
  end

  def show
    @planet = Planet.find(params[:id])
    GroupFleet.new(@planet).group!
    @setting = Setting.getInstance
    @round = Round.getInstance
    @squad = current_squad
    @map_ratio = ( @squad.map_ratio.to_f / 100 ).to_f
    redirect_to :controller => 'results', :action => 'index', :planet_id => @planet.id if @round.attack? && @planet.under_attack?


    @routes = @planet.routes
    @routes.each do |route|
      @sensor = route if route.generic_fleets.any? { |fleet| (fleet.type?(Sensor) && fleet.squad == current_squad) || (fleet.is_a_sensor? && fleet.squad == current_squad) }
    end
  end

  def move
    @planet = Planet.find(params[:id])
    GroupFleet.new(@planet).group!
    @fleets = @planet.generic_fleets.where(:squad => current_squad, :type => 'Fleet')
    @facilities = @planet.generic_fleets.where(:squad => current_squad, :type => 'FacilityFleet')
    @routes = @planet.routes
    redirect_to :close_popup if @fleets.empty? and @facilities.empty?
    #move_planet_path(@planet)
    redirect_to :back
  end


  def results
    @planet = Planet.find(params[:id])
    @fleets = @planet.generic_fleets
  end

  def map
    @round = Round.getInstance
    @setting = Setting.getInstance
    @squad = current_squad
    @map_ratio = ( @squad.map_ratio.to_f / 100 ).to_f
    @map_x_adjust = 0
    @map_y_adjust = 65
    @planets = Planet.includes(:squad).all
    @all_squads = Squad.all
    @flee_tax = (@squad.flee_tax @round).to_i
    @ground_income = 0
    @air_income = 0
    Planet.includes(:squad).each do |planet|
      @air_income += (planet.air_credits(@squad) if planet.air_credits(@squad).present?).to_i
    end
    #Planet.where(:ground_squad => @current_squad).each do |planet|
      #@ground_income += (planet.ground_credits if planet.ground_credits.present?).to_i
    #end
    @provided = (current_squad.credits + @air_income + @ground_income - @flee_tax).to_i
    if @round.move?
      @round_phase = 'Estrategia'
      @tip = "Realize movimentos, configuracao de fabricas, compra/venda de naves e nomeacao de capital ships."
    else
      @round_phase = 'Combates'
      @tip = "Informe os resultados dos combates."
    end
    @capital_ships = 0
    @facilities = 0
    @fighters = 0
    @troopers = 0
    @transports = 0
    @warriors = 0
    @commanders = 0
    @sensors = 0
    @miners = 0
    GenericFleet.where(:squad => @squad).each do |fleet|
      @capital_ships += fleet.quantity if fleet.type?(CapitalShip)
      @facilities += fleet.quantity if fleet.type?(Facility)
      @fighters += fleet.quantity if fleet.type?(Fighter)
      @troopers += fleet.quantity if fleet.type?(Trooper)
      @transports += fleet.quantity if fleet.type?(LightTransport)
      @warriors += 1 if fleet.type?(Warrior)
    end
    #@active = FacilityFleet.select { |facility| facility.squad == @current_squad && facility.balance > 0 }.count
    #@comment2 = "#{@inactive} fabricas sem produzir!" unless @active == 0
    @comment2 = ""
    @comment1 = ""
    @all_squads.each do |squad|
      @comment1 << "<span style=color:##{squad.color}>" + squad.name + " pronto!<span><br>" if squad.ready?
    end

    respond_with @planets
  end

end
