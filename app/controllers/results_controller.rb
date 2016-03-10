class ResultsController < ApplicationController
  def index
    @round = Round.getInstance
    @planet = Planet.find(params[:planet_id])
    @squads = @planet.squads
    @fleets = GenericFleet.where(:planet => @planet)
    @results = Result.where(:round => Round.getInstance, :planet => @planet)
    @squad = current_squad
    @editable = Setting.getInstance.editable_automatic_results
  end

  def create
    @results = params[:results]
    saved_results = @results.all? do |id, attributes|
      result = Result.find(id)
      result.attributes = attributes unless current_squad.ready?
      result.save
    end
    if saved_results
    end
    redirect_to planet_results_path(params[:planet_id])
  end

  def show_fog
    @squad = current_squad
    @planets = Planet.fog_seen_by(current_squad) 
  end

  def show_results
    @squad = current_squad
    @round = Round.getInstance
    @rounds = Round.results_seen_by(current_squad)
  end

  def calculate_troopers
    @planet = Planet.find(params[:id])
    trooper = TrooperBattle.new(@planet)
    trooper.fight!  
  end

  def calculate_warriors
    @planet = Planet.find(params[:id])
    trooper = JediBattle.new(@planet)
    trooper.fight!  
  end
end

