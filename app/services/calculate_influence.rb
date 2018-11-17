class CalculateInfluence
  def initialize(planet,squad)
    @planet = planet
    @squad = squad
  end

  def current
    income = 0
    income_squad = 0
    proporcao = 0.01
    presence = Setting.getInstance.presence_to_influence
    if @planet.squads.count > 1
      proporcao = @planet.count_fleet(@squad).to_f / @planet.count_fleet.to_f
      income_squad = @planet.count_fleet(@squad).to_f / presence.to_f * @planet.credits
      income_squad = @planet.credits if income_squad.to_f > @planet.credits.to_f
      income = income_squad.to_f * proporcao.to_f
    else
      income = @planet.count_fleet(@squad).to_f / presence * @planet.credits
      income = @planet.credits if income > @planet.credits
    end
    income.to_i
  end

  def update

  end
end
