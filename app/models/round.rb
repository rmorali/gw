class Round < ActiveRecord::Base

  scope :results_seen_by, lambda {|squad| joins(:results).where(:results => {:squad => squad}).group("number")}
  has_many :results

  def self.getInstance
    if Round.count == 0
      Round.create(:number => 1, :move => true)
    else
      Round.last
    end
  end

  def new_game!
    settings = Setting.getInstance
    Squad.all.each do |squad|
      home_planet = squad.home_planet
      squad.planets << home_planet
      squad.save
    end
    #Planet.create_tradeports
    Planet.create_wormholes
    Planet.randomize_special_planets
    Planet.update_income
    Squad.all.each do |squad|
      settings.initial_planets.times {squad.planets << Planet.randomize} unless settings.initial_planets == 0
      FacilityFleet.is_free
      squad.populate_planets
      squad.facility_fleets.each do |facility|
        facility.update_balance!
      end
    end
    set_planet_balance
    GenericFleet.update_all(:level => 0)
    #Tradeport.start
    set_map
  end

  def end_moving!
    Squad.update_all(:ready => nil)
    GenericFleet.update_all(:sabotaged => nil, :captured => nil, :carried_by_id => nil)
    self.move_fleets
    self.update_attributes(:move => nil, :attack => true)
    Result.create_all
    set_map
  end

  def end_round!
    self.update_attributes(:move => nil, :attack => nil, :done => true)
    self.apply_results
    Squad.all.each do |squad|
      squad.generate_profits!
      squad.facility_fleets.each do |facility|
        facility.update_balance!
      end
      squad.ready = nil
      squad.credits -= squad.flee_tax self
      squad.save!
    end
    FacilityFleet.where(:moving => true).each do |facility|
      facility.reassembly unless facility.planet.has_an_enemy?(Facility, facility.squad) || facility.planet.has_an_enemy?(CapitalShip, facility.squad) || facility.planet.has_an_enemy?(Fighter, facility.squad) || facility.planet.has_an_enemy?(LightTransport, facility.squad)
    end
    Fleet.where(:moving => true).each do |fleet|
      fleet.reassembly unless fleet.planet.has_an_enemy?(Facility, fleet.squad) || fleet.planet.has_an_enemy?(CapitalShip, fleet.squad) || fleet.planet.has_an_enemy?(Fighter, fleet.squad) || fleet.planet.has_an_enemy?(LightTransport, fleet.squad)
    end
    Round.create(:number => self.number + 1, :move => true)
    Tradeport.start
    set_map
    set_planet_balance
  end
 # VERIFICAR AQUI NAO PODE ATUALIZAR BALANCE DO PLANETA SE A FACILITY FOR CAPTURADA
 # UMA FORMA PARECE SER MARCAR COMO SABOTADA NO CASO DE CAPTURAR
  def set_planet_balance
    Planet.all.each do |planet|
      planet.update_balance
    end
  end

  def set_map
    Planet.all.each do |planet|
      planet.set_ownership
      planet.set_ground_ownership
    end
  end

  def check_state
    squads_ready = Squad.where(:ready => true)
    if Round.getInstance.move?
      Round.getInstance.end_moving! if squads_ready.count == Squad.all.count
    else
      Round.getInstance.end_round! if squads_ready.count == Squad.all.count
    end
  end

  def move_fleets
    GenericFleet.moving.each(&:move!)
  end

  def apply_results
    Result.where(:round => self).each do |result|
      result.sabotage! unless result.sabotaged == nil
      result.blast! unless result.blasted == nil || result.blasted <= 0
      result.flee! unless result.fled == nil || result.fled <= 0
      result.capture! unless result.captured == nil || result.captured <= 0
    end
  end
  
  def reset_database
    Planet.update_all(:squad_id => nil, :ground_squad_id => nil, :wormhole => nil, :credits => 0, :last_player_id => nil, :first_player_id => nil, :special => nil)
    Goal.update_all(:used => nil)
    Route.where(:distance => 2).destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE generic_fleets")
    ActiveRecord::Base.connection.execute("TRUNCATE results")
    ActiveRecord::Base.connection.execute("TRUNCATE users")
    ActiveRecord::Base.connection.execute("TRUNCATE squads")
    ActiveRecord::Base.connection.execute("TRUNCATE tradeports")
    ActiveRecord::Base.connection.execute("TRUNCATE rounds")
    User.create(:email => 'setup@xws.com', :password => '123456')
  end

  def create_test_squads quantity
    User.create(:email => 'setup@xws.com', :password => '123456')
    rebel_user = User.create(:email => 'rebel@rebel.com', :password => '123456')
    rebel_squad = Squad.create(:name => 'Rebel', :color => 'FF0000', :user => rebel_user, :faction => 'rebel', :home_planet => Planet.find(5), :credits => 1000, :goal => Goal.get_goal, :map_ratio => 100, :map_background => true)
    empire_user = User.create(:email => 'empire@empire.com', :password => '123456')
    empire_squad = Squad.create(:name => 'Empire', :color => '00FF00', :user => empire_user, :faction => 'empire', :home_planet => Planet.find(10), :credits => 1000, :goal => Goal.get_goal, :map_ratio => 100, :map_background => true)

    if quantity == 4
      mand_user = User.create(:email => 'mand@mand.com', :password => '123456')
      mand_squad = Squad.create(:name => 'Mandalorian', :color => 'EE82EE', :user => mand_user, :faction => 'pirate', :home_planet => Planet.find(15), :credits => 1000, :goal => Goal.get_goal, :map_ratio => 100, :map_background => true)
      merc_user = User.create(:email => 'merc@merc.com', :password => '123456')
      merc_squad = Squad.create(:name => 'Mercenary', :color => 'FFFF00', :user => merc_user, :faction => 'mercenary', :home_planet => Planet.find(20), :credits => 1000, :goal => Goal.get_goal, :map_ratio => 100, :map_background => true)
    end
  end


end
