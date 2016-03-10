class TrooperBattle
  def initialize(planet)
    @planet = planet
  end

  def fight!
    bomb_troopers if troopers && bombers             
    duel_until_death if enemy_troopers?
  end

  def only_one_squad_left?
    troopers.select { |trooper| trooper.blasted.to_s.to_i + trooper.fled.to_s.to_i + trooper.not_landed.to_s.to_i < trooper.quantity.to_s.to_i }.map(&:squad).uniq.size == 1
  end

  private

  def duel_until_death
    catch :fight_is_over do
      while 1 == 1
        troopers.group_by(&:squad).each do |squad, troopers|
          trooper = troopers.sample
          damage_trooper(trooper)
          trooper.save
          if only_one_squad_left? || only_one_left?
            fleets_from_type("Trooper").update_all(:automatic => true)
            throw :fight_is_over    
          end
        end
      end
    end
  end


  def only_one_left?
    troopers.one? { |trooper| trooper.blasted.to_s.to_i - trooper.fled.to_s.to_i - trooper.not_landed.to_s.to_i < trooper.quantity.to_s.to_i }
  end

  def damage_trooper(trooper)
    return if trooper.blasted == trooper.quantity - trooper.fled.to_s.to_i - trooper.not_landed.to_s.to_i
    if random_damage_to_trooper?
      trooper.blasted = 0 if trooper.blasted == nil
      trooper.blasted += 1
    end
  end

  def bomb_troopers
    bombers.each do |bomber|
      troopers.each do |trooper|
        trooper.blasted = (trooper.quantity - trooper.fled.to_s.to_i - trooper.not_landed.to_s.to_i) / rand(2..5) if bombers.any? { |unit| (unit.skill && unit.skill.acronym == 'ATB') && unit.squad != trooper.squad } && trooper.quantity >= 10 && trooper.squad != bomber.squad
        trooper.save
      end
    end
    fleets_from_type("Trooper").update_all(:automatic => true)
  end

  def enemy_troopers?
    troopers.map(&:squad).uniq.size > 1
  end

  def random_damage_to_trooper?
    [true, false].sample
  end

  def warriors
    @warriors ||= fleets_from_type("Warrior")
  end

  def troopers
    @troopers ||= fleets_from_type("Trooper")
  end

  def bombers
    @capital_ships ||= fleets_from_type("CapitalShip")
    @bombers = @capital_ships.select { |cs| cs.skill && cs.skill.acronym == 'ATB' && cs.blasted.to_i < 1 && cs.fled.to_i < 1 && cs.captured.to_i < 1 && cs.sabotaged != true }
    @bombers
  end

  def fleets_from_type(type)
    @planet.results.joins(:generic_unit).where(generic_unit: {type: type}, round: Round.getInstance)
  end
end
