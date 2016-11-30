class FacilityFleet < GenericFleet
  before_create :default_values
  validates_presence_of :facility, :squad

  belongs_to :facility, :foreign_key => :generic_unit_id
  belongs_to :producing_unit, :class_name => "Unit"
  belongs_to :producing_unit2, :class_name => "Unit"
  belongs_to :destination, :class_name => "Planet"

  delegate :capacity, :to => :facility
  delegate :secondary_capacity, :to => :facility
  delegate :price, :to => :facility

  class << self
    def is_free
      FacilityFleet.skip_callback(:create, :before, :subtract_credits_from_squad)
    end
  end

  def move planet
      self.destination = planet
      if planet == nil
        self.moving = nil
      else
        self.moving = true
      end
      self.save!
      self
  end

  def flee! quantity
    fleeing_facility = FacilityFleet.new self.attributes
    fleeing_facility.destination = planet.best_route_for(squad)
    fleeing_facility.moving = true
    fleeing_facility.save!
    self.quantity = 0
    save
    fleeing_facility.move!
    fleeing_facility
  end

  def move!
    update_attributes(:planet => destination)
  end

  def reassembly
    update_attributes(:moving => nil, :destination_id => nil)
  end

  def update_balance!
    self.balance = 0 
    self.save
    return if self.moving? || self.planet.tradeport
    self.balance += default_capacity
    self.save
  end

  def produce! unit, quantity, planet, squad
    unless quantity * unit.price > self.balance
      Fleet.create_from_facility unit, quantity, planet, squad
      self.balance -= quantity * unit.price
      self.save
    end
  end

  def upgrade!
    if self.squad.credits >= upgrade_cost
      self.squad.credits -= upgrade_cost
      self.squad.save
      self.level += 1
      self.save
    end
  end

  def default_capacity 
    if sabotaged?
      ((capacity + current_upgrade_ratio) * 0.50).to_i
    elsif captured?
      0
    else
      (capacity + current_upgrade_ratio).to_i
    end
  end

  def upgrade_cost
    Setting.getInstance.facility_upgrade_cost
  end

  def upgrade_ratio
    Setting.getInstance.facility_upgrade_rate
  end

  def current_upgrade_ratio
    upgrade_ratio * level
  end
 
  def total_capacity
    (default_capacity + balance).to_i
  end

  def name
    if moving?
      facility.description
    else
      facility.name
    end
  end
  
private

  def default_values
    self.quantity = 1
  end

end
