class JediBattle
  def initialize(planet)
    @planet = planet
  end

  def fight!
    if enemy_jedis?
      duel_until_death
    else
      shoot_jedis
    end
  end

  def only_one_squad_left?
    warriors.select { |warrior| warrior.blasted.to_s.to_i < warrior.quantity.to_s.to_i }.map(&:squad).uniq.size == 1
  end

  private

  def duel_until_death
    catch :fight_is_over do
      while 1 == 1
        warriors.group_by(&:squad).each do |squad, warriors|
          warrior = warriors.sample
          damage_jedi(warrior)
          warrior.save
          if only_one_squad_left? || only_one_left?
            fleets_from_type("Warrior").update_all(:automatic => true)
            throw :fight_is_over    
          end
        end
      end
    end
  end


  def only_one_left?
    warriors.one? { |warrior| warrior.blasted.to_s.to_i < warrior.quantity.to_s.to_i }
  end

  def shoot_jedis
    warriors.each do |warrior|
      #if enemy_troops_for?(warrior)
        3.times do
          damage_jedi(warrior)
        end
      #end
      warrior.save
    end
    fleets_from_type("Warrior").update_all(:automatic => true)
  end

  def damage_jedi(jedi)
    jedi.blasted = 1 if jedi.blasted == nil
    return if jedi.blasted == jedi.quantity
    if random_damage_to_warrior?
      jedi.blasted += 1
    end
  end

  def enemy_jedis?
    warriors.map(&:squad).uniq.size > 1
  end

  def random_damage_to_warrior?
    [true, false].sample
  end

  def warriors
    @warriors ||= fleets_from_type("Warrior")
  end

  def troopers
    @troopers ||= fleets_from_type("Trooper")
  end

  def enemy_troops_for?(jedi)
    troopers.any? {|trooper| trooper.squad != jedi.squad}
  end

  def fleets_from_type(type)
    @planet.results.joins(:generic_unit).where(generic_unit: {type: type}, round: Round.getInstance)
  end

end
