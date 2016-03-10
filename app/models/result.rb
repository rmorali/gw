class Result < ActiveRecord::Base

  #attr_accessible :captor_id, :blasted, :captured, :fled

  belongs_to :generic_unit
  belongs_to :planet
  belongs_to :generic_fleet
  belongs_to :squad
  belongs_to :captor, :class_name => "Squad", :foreign_key => 'captor_id'
  belongs_to :round
  belongs_to :producing_unit, :class_name => "Unit"
  belongs_to :producing_unit2, :class_name => "Unit"
  belongs_to :weapon1, :class_name => "GenericUnit"
  belongs_to :weapon2, :class_name => "GenericUnit"
  belongs_to :skill


  validates_presence_of :round, :generic_fleet, :generic_unit, :squad, :planet, :quantity 
  validates_numericality_of :blasted, :fled, :captured, :not_landed, :allow_nil => true
  validate :captor_if_captured
  validate :posted_results
  #validate :automatic_results  

  def self.create_all
    GenericFleet.all.each do |fleet|
      Result.create(:generic_fleet_id => fleet.id, :planet => fleet.planet, :quantity => fleet.quantity, :generic_unit_id => fleet.generic_unit.id, :round => Round.getInstance, :squad => fleet.squad, :final_quantity => fleet.quantity, :producing_unit_id => fleet.producing_unit_id, :producing_unit2_id => fleet.producing_unit2_id, :fleet_name => fleet.fleet_name, :weapon1_id => fleet.weapon1_id, :weapon2_id => fleet.weapon2_id, :leader => fleet.leader, :skill_id => fleet.skill_id, :description => fleet.description, :moving => fleet.moving ) if fleet.planet.under_attack?
    end
    Planet.all.each do |planet|
      last_player = planet.squads[rand(planet.squads.count)]
      available_squads = planet.squads.reject {|x| x == last_player}
      first_player = available_squads[rand(planet.squads.count - 1)]
      planet.last_player = last_player
      planet.first_player = first_player
      planet.distance = rand(4..8)
      planet.save
    end
  end

  def blast!
    self.generic_fleet.blast! self.blasted
    self.final_quantity = self.quantity - self.blasted
    save
  end

  def flee!
    self.generic_fleet.flee! self.fled if self.generic_fleet.respond_to? :flee!
    self.final_quantity = self.quantity - self.fled
    save
  end

  def capture!
    self.generic_fleet.capture! self.captured, self.captor
    #self.squad = self.captor
    save
  end

  def sabotage!
    self.generic_fleet.sabotage! if sabotaged?
  end

  def captor_if_captured
    if self.captured and !captor.is_a?(Squad)
      errors.add :captor, :empty
    else
      true
    end
  end

  def posted_results
    posted_result = self.captured.to_i + self.blasted.to_i + self.fled.to_i + self.not_landed.to_i
    if posted_result > self.quantity.to_i || posted_result < 0
      errors.add :blasted, 'exceed fleet quantity'
    else
      true
    end
  end

  def automatic_results
    if self.automatic? 
      errors.add :blasted, 'automatic result cannot be changed' if self.automatic?
    else
      true
    end     
  end

  def editable?(result)
    edit = true
    case result
      when 'Blasted'
        edit = false if self.automatic? && Setting.getInstance.editable_automatic_results != true 
      when 'Fled'
        edit = false if (self.type?(Facility) && !self.generic_fleet.moving?) || self.type?(Sensor) || ( self.automatic? && Setting.getInstance.editable_automatic_results != true )
      when 'Captured'
        edit = false if self.type?(Trooper) || self.type?(Commander) || self.type?(Warrior) || ( self.automatic? && Setting.getInstance.editable_automatic_results != true )
      when 'NotLanded'
        edit = false if !self.type?(Trooper) || ( self.automatic? && Setting.getInstance.editable_automatic_results != true )
      when 'Captor'
        edit = false if self.type?(Trooper) || self.type?(Commander) || self.type?(Warrior) || ( self.automatic? && Setting.getInstance.editable_automatic_results != true )
      when 'Sabotaged'
        edit = false unless ( self.type?(Facility) || self.type?(CapitalShip) ) && self.automatic != true
    end
    edit
  end

  def type?(type)
    self.generic_unit.is_a? type
  end

  def show_results
    results = ' '
    if self.present?
      results << self.blasted.to_s+'d ' if self.blasted != nil and self.blasted != 0
      results << self.fled.to_s+'f ' if self.fled != nil and self.fled != 0
      results << self.captured.to_s+'c ' if self.captured != nil and self.captured != 0
      results << self.not_landed.to_s+'orbit ' if self.not_landed != nil and self.not_landed != 0
      results << 'sabot' if self.sabotaged == true
      results << '*' if self.automatic == true
    end
    results
  end

  def show
    case generic_unit.type
    when 'CapitalShip'
      unless skill_id
        "#{generic_unit.name}"
      else
        "#{generic_unit.name} + #{skill.acronym}"
      end
    when 'Warrior'
      "#{generic_unit.name} (#{quantity} vidas)"
    when 'Commander'
      "#{name}"
    when 'Facility'
      unless moving?
        "#{generic_unit.name}"
      else
        "#{generic_unit.description}"
      end
    else
       unless weapon1_id
         "#{quantity} #{generic_unit.name}"
       else
         "#{quantity} #{generic_unit.name} + #{weapon1.name}"
       end
    end
  end

  def span_style
    style = []
    style << "font-size:11px;font-weight:normal;color:##{self.squad.color};"
    case self.generic_unit.type
    when 'Armament'
      
    when 'Fighter'

    when 'Skill'
      style << "border-radius:20%; border:solid 1px; padding:1px"
    when 'CapitalShip'
      style << "font-weight:bolder; font-size:12px"
    when 'Facility'
      style << "font-weight:bolder; font-size:12px; background-color:#000040"
    when 'LightTransport'

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

end
