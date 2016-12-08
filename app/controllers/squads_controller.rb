class SquadsController < ApplicationController

  def new
    @squad = Squad.new
    @colors = %w[Vermelho Verde Amarelo Roxo Branco Magenta]
    @planets = Planet.where(:tradeport => nil)
    @goal = Goal.get_goal
  end

  def create
    squad = Squad.create(params[:squad])
    current_user.squad = squad
    squad.credits = Setting.getInstance.initial_credits
    case params[:squad][:color]
      when 'Vermelho'
        color = 'FF0000'
      when 'Verde'
        color = '00FF00'
      when 'Amarelo'
        color = 'FFFF00'
      when 'Roxo'
        color = '66CCFF'
      when 'Branco'
        color = 'FFFFFF'
      when 'Magenta'
        color = 'EE82EE'
    end
    squad.color = color
    squad.map_ratio = 100
    squad.save!
    #redirect_to :controller => 'generic_units', :action => 'ships', :id => squad.id
    redirect_to :fleets 
  end

  def edit

  end

  def ready
    @squad = current_squad
    @squad.ready!
    @squad.reload
    @round = Round.getInstance
    if @squad.ready == true
      @status = "preparado e aguardando"
    else
      @status = "em fase de estrategia" if @round.move == true
      @status = "em fase de combates" if @round.attack == true
    end
  end

  def transfer
    @squad = current_squad
    @squads = Squad.all.reject! { |squad| squad == @squad }
  end

  def transfer_credits
    unless params[:transfer][:credits].empty? || params[:transfer][:squad].empty?
      @squad_destination = Squad.find(params[:transfer][:squad])
      @quantity = (params[:transfer][:credits]).to_i
      current_squad.transfer_credits @quantity, @squad_destination
      redirect_to :back
    end
  end

  def goal
    #@squad = Squad.find(params[:id])
    @squad = current_squad
    @goal = @squad.goal
    @goals = Goal.all
  end


end

