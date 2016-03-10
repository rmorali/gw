class RoundsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @squads = Squad.all
    @user = User.all
  end

  def new_game
    @round = Round.getInstance.new_game!
    render :text => 'New Game OK - Retorne a pagina anterior'
  end

  def end_moving
    round = Round.getInstance.end_moving!
    render :text => 'Passar MOVIMENTO OK - Retorne a pagina anterior'
  end

  def end_round
    round = Round.getInstance.end_round!
    render :text => 'Passar o TURNO OK - Retorne a pagina anterior'
  end

  def create_2_test_squads
    round = Round.getInstance.create_test_squads 2
    render :text => '2 squads de teste criados com sucesso. Retorno a pagina anterior'
  end

  def create_4_test_squads
    round = Round.getInstance.create_test_squads 4
    render :text => '4 squads de teste criados com sucesso. Retorno a pagina anterior'
  end

  def reset_database
    round = Round.getInstance.reset_database
    render :text => 'Banco de dados RESETADO'
  end

end

