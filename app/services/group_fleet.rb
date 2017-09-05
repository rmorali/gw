class GroupFleet
  def initialize(planet)
    @planet = planet
  end

  def group!
    groups.each do |duplicates|
      first_one = duplicates.shift
      duplicates.each do |double|
        next unless first_one.is_groupable?
        first_one.increment!(:quantity, double.quantity)
        double.destroy
      end
    end
  end

  private

  def groups
    @planet.generic_fleets.group_by do |unit|
      unit_attributes(unit)
    end.values
  end

  def unit_attributes(unit)
    [
      unit.generic_unit,
      unit.planet,
      unit.squad,
      unit.moving,
      unit.destination,
      unit.carried_by,
      unit.weapon1,
      unit.weapon2,
      unit.skill
    ]
  end
end
