class CalculateInfluence
  def initialize(planet,squad)
    @planet = planet
    @squad = squad
  end

  def current
    income = 0
    presence = Setting.getInstance.presence_to_influence
    if @planet.under_attack?
      income = @planet.count_fleet(@squad).to_f / @planet.count_fleet.to_f * @planet.credits
    else
      income = @planet.count_fleet(@squad).to_f / presence * @planet.credits
      income = @planet.credits if income > @planet.credits
    end
    income.to_i
  end

  def update

  end
end
