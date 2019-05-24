class Fleet < GenericFleet

  def move quantity, planet
    if planet == nil
      cancel_moves
      self
    elsif self.generic_unit.hyperdrive == false || self.type?(Commander) || self.type?(Trooper) || self.type?(Armament)
      self
    else
      if self.quantity == 1 || quantity == self.quantity
        moving_fleet = self
      else
        moving_fleet = Fleet.new self.attributes
      end
      moving_fleet.destination = planet
      moving_fleet.quantity = quantity
      moving_fleet.moving = true
      moving_fleet.save
      unless self.cargo.empty?
        if self.quantity == quantity
          self.cargo.each do |cargo|
            cargo.moving = moving_fleet.moving
            cargo.destination = moving_fleet.destination
            cargo.carried_by = moving_fleet
            cargo.save
          end
        else
          self.unload_all
        end
      end
      self.quantity -= quantity unless moving_fleet == self
      save
      moving_fleet
    end
  end

  def move!
    update_attributes(:planet => destination, :destination => nil, :moving => nil)
    GroupFleet.new(self.planet).group!
  end

  def reassembly
    update_attributes(:moving => nil, :destination_id => nil )
  end

  def flee! quantity
    fleeing_fleet = self.clone
    fleeing_fleet.update_attributes(:quantity => quantity, :moving => true, :destination => planet.best_route_for(squad) )
    self.quantity -= quantity
    save
    fleeing_fleet.move!
    fleeing_fleet
  end

  def self.create_from_facility unit, quantity, planet, squad
    if unit.type == 'CapitalShip'
      quantity.times do
        Fleet.create(:generic_unit_id => unit.id, :planet_id => planet.id, :squad_id => squad.id, :fleet_name => '', :quantity => 1, :level => 0, :round => Round.getInstance.number)
      end
    else
      fleet = find_or_create_by_generic_unit_id_and_planet_id_and_squad_id_and_weapon1_id_and_weapon2_id_and_carried_by_id_and_moving(:generic_unit_id => unit.id, :planet_id => planet.id, :squad_id => squad.id, :fleet_name => '', :weapon1_id => nil, :weapon2_id => nil, :carried_by_id => nil, :moving => nil, :level => 0, :round => Round.getInstance.number)
      if fleet.quantity
        fleet.quantity += quantity
      else
        fleet.quantity = quantity
      end
      fleet.save
    end
  end

end
