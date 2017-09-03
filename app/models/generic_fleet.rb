class GenericFleet < ActiveRecord::Base
  default_scope :order => "squad_id ASC, moving ASC, destination_id ASC, generic_unit_id ASC, updated_at DESC"
  scope :owned_by, lambda {|squad| where(:squad => squad)}
  scope :moving, where(:moving => true)
  belongs_to :squad
  belongs_to :planet
  belongs_to :generic_unit
  belongs_to :destination, :class_name => "Planet"
  belongs_to :carried_by, :class_name => "GenericFleet"
  belongs_to :weapon1, :class_name => "Armament"
  belongs_to :weapon2, :class_name => "Armament"
  belongs_to :skill

  validates_format_of :fleet_name, :with => /^[a-zA-Z\d ]*$/i,
:message => "no special characteres."

  after_save :destroy_if_empty

  delegate :name, :to => :generic_unit

  def blast! quantity
    self.quantity -= quantity
    save
  end

  def capture! quantity, squad
    FacilityFleet.is_free
    captured_fleet = self.clone
    captured_fleet.update_attributes(:squad => squad, :quantity => quantity, :type => self.type, :level => self.level)
    captured_fleet.captured = true
    captured_fleet.save
    self.quantity = self.quantity - quantity
    save
  end

  def sabotage!
    self.sabotaged = true
    self.save
  end


  def type?(type)
    generic_unit.is_a? type
  end

  def destroy_if_empty
    destroy if self.quantity == 0
  end

  def to_s
    name
  end

  def change_fleet_name name
    self.fleet_name = name
    save
  end

  def show_results
    round = Round.getInstance
    result = Result.where(:generic_fleet => self, :round => round).first
    results = ''
    if result.present? && round.attack?
      results << result.blasted.to_s+'d ' if result.blasted != nil
      results << result.fled.to_s+'f ' if result.fled != nil
      results << result.captured.to_s+'c ' if result.captured != nil
      results << 'sabot' if result.sabotaged == true
    end
    results
  end

  def to_label
    selling_price = (generic_unit.price * 0.50).to_i
    "#{quantity} #{name} - #{selling_price} cada"
  end

  def show
    case generic_unit.type
    when 'CapitalShip'
      unless skill_id
        "#{name}"
      else
        "#{name} + #{skill.acronym}"
      end
    when 'Warrior'
      "#{name} (#{quantity} vidas)"
    when 'Commander'
      "#{name}"
    when 'Skill'
      "#{quantity} #{name}"
    when 'Facility'
      unless moving?
        "#{name}"
      else
        "#{generic_unit.description}"
      end
    else
      info = ""
      info << "#{quantity} #{name}"
      info << " + #{weapon1.acronym}" if weapon1_id
      info << " + #{weapon2.acronym}" if weapon2_id
      info
    end
  end

  def description
    info = []
    info << "<b>#{self.generic_unit.type.to_s.upcase}</b> ".to_s
    info << " (Preco: #{self.generic_unit.price})"
    case self.generic_unit.type
    when 'Armament'
      info << "<br>- Equipa Fighters e Bombers"
      info << "<br>- Torpedos destroem Fabricas"
    when 'Fighter'
      info << "<br>- Unidades Pilotaveis"
    when 'Skill'
      info << "<br>- Equipa Capital Ships"
    when 'CapitalShip'
      info << "<br>- Nome: <b>#{fleet_name}</b>"
      info << "<br>- Ataques de Longa Distancia"
      info << "<br>- Abordagem / Captura de Fabricas"
      info << "<br>- Transporte de Unidades"
      info << "<br>- Skill: #{skill.name}" if skill

    when 'Facility'
      #info << "<br>- Pontos de Producao: #{self.balance.to_i}"
      info << "<br>- Upgrades: #{self.level} (+#{current_upgrade_ratio})"
      info << "<br><b>- Bloqueada/Sabotada (-#{(default_capacity * 0.50).to_i})</b>" if self.sabotaged?
      info << "<br><b>- Capturada </b>" if self.captured?
      info << "<br>- Producao por turno: #{self.default_capacity}"
      info << "<br>- Producao / Treinamento de Unidades"
      info << "<br>- Congela Nivel e Pontos se movimentada"
    when 'LightTransport'
      info << "<br>- Abordagem/Captura de Fabricas"
      #info << "<br>- Raid Missions Longa Distancia"
      info << "<br>- Transporte de Unidades"
    when 'Warrior'
      info << "<br>- Espionagem"
      info << "<br>- Bloqueio de Construcao"
      info << "<br>- Sabotagem de Fabricas e CS"
      info << "<br>- Lideranca de Tropas no BF2"
    when 'Sensor'
      info << "<br>- Detecta Frotas Inimigas"
    when 'Trooper'
      info << "<br>- Dominio Terrestre"
      info << "<br>- Minimo #{Setting.getInstance.minimum_quantity} por planeta"
    else

    end
      info << "<br>- Arma1: #{weapon1.name}" if weapon1
      info << "<br>- Arma2: #{weapon2.name}" if weapon2
      if is_a_builder?
        info << "<br>- Construcao de Fabricas"
        info << "<br>- Maximo #{Setting.getInstance.maximum_facilities} fabricas por planeta"
      end
    info << "<br>- #{generic_unit.description}" if generic_unit.description
    info.join(' ')
  end

  def span_style
    style = []
    style << "font-size:9px;font-weight:normal;color:##{self.squad.color};"
    case self.generic_unit.type
    when 'Armament'
      style << "border-radius:20%; border:solid 1px; padding:1px; font-size:9px"
    when 'Fighter'

    when 'Skill'
      style << "border-radius:20%; border:solid 1px; padding:1px"
    when 'CapitalShip'
      style << "font-weight:bolder; font-size:10px"
    when 'Facility'
      style << "font-weight:bolder; font-size:10px; background-color:#000040"
    when 'LightTransport'
      style << "font-weight:bolder; font-size:9px"
    when 'Warrior'
      style << "border-radius:20%; border:dotted 1px; padding:2px; background-color:#331100"
    when 'Sensor'

    when 'Trooper'
      style << "background-color:#331100"
    when 'Commander'
      style << "outline:solid"
    else

    end
    style.join(' ')
  end

  def load_in carrier, qtt
    if self.type?(Fighter) || self.type?(LightTransport) || self.type?(Sensor)
      carried_units = 0
      carrier.cargo.each do |cargo|
        carried_units += cargo.quantity if cargo.type?(Fighter) || cargo.type?(LightTransport) || cargo.type?(Sensor)
      end
      carrier_available_capacity = carrier.heavy_loading_capacity - carried_units
      if qtt > carrier_available_capacity && carrier_available_capacity <= carrier.heavy_loading_capacity
        qtt = carrier_available_capacity
      elsif qtt > carrier_available_capacity && carrier_available_capacity == 0
        return
      else
        qtt = qtt
      end
    else
      carried_units = 0
      carrier.cargo.each do |cargo|
        carried_units += cargo.quantity if cargo.type?(Trooper) || cargo.type?(Armament) || cargo.type?(Warrior)
      end
      carrier_available_capacity = carrier.light_loading_capacity - carried_units
      if qtt > carrier_available_capacity && carrier_available_capacity <= carrier.light_loading_capacity
        qtt = carrier_available_capacity
      elsif qtt > carrier_available_capacity && carrier_available_capacity == 0
        return
      else
        qtt = qtt
      end
    end

    if qtt == self.quantity
      self.carried_by = carrier
      self.moving = carrier.moving
      self.destination = carrier.destination
      self.save
      #self.group_fleets
    elsif qtt != 0
      not_loaded_fleet = self.clone
      not_loaded_fleet.quantity -= qtt
      not_loaded_fleet.save
      self.carried_by = carrier
      self.quantity = qtt
      self.moving = carrier.moving
      self.destination = carrier.destination
      self.save
      #self.group_fleets
    end
  end

  def unload_from carrier, qtt
    if qtt == self.quantity
      self.carried_by = nil
      self.moving = nil
      self.destination = nil
      self.save
      #self.group_fleets
    else
      unloaded_fleet = self.clone
      unloaded_fleet.quantity = qtt
      unloaded_fleet.carried_by = nil
      unloaded_fleet.moving = nil
      unloaded_fleet.destination = nil
      unloaded_fleet.save
      self.quantity -= qtt
      self.moving = carrier.moving
      self.destination = carrier.destination
      self.save
      GroupFleet.new(self.planet)
    end
  end

  def carrier
    carried_by
  end

  def cargo
    GenericFleet.select { |fleet| fleet.carried_by_id == self.id }
  end

  def unload_all
    self.cargo.each do |cargo|
      cargo.moving = nil
      cargo.destination = nil
      cargo.carried_by = nil
      cargo.save
    end
  end

  def arm_with armament, slot
    if armament.quantity == self.quantity
      self.update_attributes(:weapon1 => armament.generic_unit) if slot == 1
      self.update_attributes(:weapon2 => armament.generic_unit) if slot == 2
      armament.update_attributes(:quantity => armament.quantity - self.quantity)
    elsif armament.quantity > self.quantity
      self.update_attributes(:weapon1 => armament.generic_unit) if slot == 1
      self.update_attributes(:weapon2 => armament.generic_unit) if slot == 2
      armament.update_attributes(:quantity => armament.quantity - self.quantity)
    else
      not_armed_fleet = self.clone
      not_armed_fleet.quantity -= armament.quantity
      not_armed_fleet.save!
      self.update_attributes(:weapon1 => armament.generic_unit, :quantity => armament.quantity) if slot == 1
      self.update_attributes(:weapon2 => armament.generic_unit, :quantity => armament.quantity) if slot == 2
      armament.update_attributes(:quantity => 0)
    end
  end

  def disarm slot
    if slot == 1
      discharged_armaments = self.clone
      discharged_armaments.generic_unit_id = self.weapon1.id
      discharged_armaments.moving = nil
      discharged_armaments.destination = nil
      discharged_armaments.weapon1 = nil
      discharged_armaments.weapon2 = nil
      discharged_armaments.save!
      self.update_attributes(:weapon1 => nil)
   else
      discharged_armaments = self.clone
      discharged_armaments.generic_unit_id = self.weapon2.id
      discharged_armaments.moving = nil
      discharged_armaments.destination = nil
      discharged_armaments.weapon1 = nil
      discharged_armaments.weapon2 = nil
      discharged_armaments.save!
      self.update_attributes(:weapon2 => nil)
   end
   #group
  end

  def install skill
    if skill.quantity == self.quantity
      self.update_attributes(:skill => skill.generic_unit)
      skill.update_attributes(:quantity => skill.quantity - self.quantity)
    elsif skill.quantity > self.quantity
      self.update_attributes(:skill => skill.generic_unit)
      skill.update_attributes(:quantity => skill.quantity - self.quantity)
    else
      not_skilled_fleet = self.clone
      not_skilled_fleet.quantity -= skill.quantity
      not_skilled_fleet.save!
      self.update_attributes(:skill => skill.generic_unit, :quantity => skill.quantity)
      skill.update_attributes(:quantity => 0)
    end
  end

  def uninstall_skill
    discharged_skills = self.clone
    discharged_skills.generic_unit_id = self.skill.id
    discharged_skills.moving = nil
    discharged_skills.destination = nil
    discharged_skills.skill = nil
    discharged_skills.save!
    self.cancel_moves if self.skill.acronym == 'ENG'
    self.update_attributes(:skill => nil)
    GroupFleet.new(self.planet)
  end

  def is_a_sensor?
    #true if self.type?(Sensor) || (self.skill && self.skill.acronym == 'SAR')
    true if self.skill && self.skill.acronym == 'SAR'
  end

  def is_a_bomber?
    true if self.type?(CapitalShip) && (self.skill && self.skill.acronym == 'ATB')
  end

  def is_a_builder?
    true if self.type?(Setting.getInstance.builder_unit.constantize)
  end

  def get_leadership
    self.squad.debit 1200
    self.leader = true
    save
  end

  def is_movable?
    true unless self.generic_unit.hyperdrive == false || self.planet.routes(self).empty? || self.carried_by != nil
  end

  def is_groupable?
    return nil if self.type?(CapitalShip) || self.type?(Facility)
    true
  end

  def is_transportable?
    true if ( self.type?(Fighter) || self.type?(Armament) || self.type?(Sensor) || self.type?(Warrior) ||self.type?(Miner) || self.type?(Trooper) || self.type?(Skill) ) && self.moving != true && self.carried_by == nil
  end

  def heavy_loading_capacity
    self.generic_unit.heavy_loading_capacity * self.quantity
  end

  def light_loading_capacity
    self.generic_unit.light_loading_capacity * self.quantity
  end

  def cancel_moves
    GenericFleet.where(:carried_by => self).update_all(:moving => nil, :destination_id => nil)
    self.update_attributes(:moving => nil, :destination_id => nil)
    GroupFleet.new(self.planet)
  end

=begin
  def group_fleets
    unless self.generic_unit.is_a?(Facility) || self.generic_unit.is_a?(CapitalShip)
      fleets = planet.generic_fleets.where(:generic_unit_id => self.generic_unit_id, :planet => self.planet, :squad => self.squad, :moving => self.moving, :destination_id => self.destination_id, :carried_by_id => self.carried_by_id, :weapon1_id => self.weapon1_id, :weapon2_id => self.weapon2_id, :skill_id => self.skill_id )
      total_quantity = 0
      old_unit_round = fleets.first.round
      fleets.each do |fleet|
        unless fleet == self
          total_quantity += fleet.quantity
          fleet.quantity = 0
          fleet.save
        end
      end
      self.quantity += total_quantity
      self.round = old_unit_round
      save
    end
  end
=end

end
