class GroupFleet
  def initialize(planet)
    @planet = planet
    destroy_dups
  end

  def groups
    @planet.generic_fleets.group_by{ |unit| [unit.generic_unit, unit.planet, unit.squad, unit.moving, unit.destination, unit.carried_by, unit.weapon1, unit.weapon2, unit.skill] }.values
  end

  def destroy_dups
    groups.each do |duplicates|
      first_one = duplicates.shift
      duplicates.each do |double|
        next unless first_one.is_groupable?
        first_one.update_attributes(:quantity => first_one.quantity += double.quantity)
        double.destroy
      end
    end
  end
end
