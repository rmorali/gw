require 'forgery'
Factory.define :generic_unit do |f|
  f.name { Forgery::Name.full_name }
  f.price { Forgery::Basic.number }
  f.factions 'empire'
  f.description 'comboio'
  f.heavy_loading_capacity 10
  f.light_loading_capacity 100
end

Factory.define :planet do |f|
  f.name Forgery::Name.full_name
  f.credits 1000
  f.balance 1000
end

Factory.define :squad do |f|
  f.name Forgery::Name.full_name
  f.credits { Forgery::Basic.number(:at_least => 5000, :at_most => 10000) }
  f.color '00FF00'
  f.map_ratio 100
  f.faction 'empire'
  f.home_planet {|a| a.association(:planet)}
end

Factory.define :generic_fleet do |f|
  f.generic_unit {|a| a.association(:generic_unit) }
  f.squad {|a| a.association(:squad) }
  f.quantity Forgery::Basic.number
end

Factory.define :facility, :class => Facility, :parent => :generic_unit do |f|
  f.price 1200
end

Factory.define :fleet, :class => Fleet, :parent => :generic_fleet do |f|
end

Factory.define :unit, :class => Unit, :parent => :generic_unit do |f|
end

Factory.define :fighter, :class => Fighter, :parent => :unit do |f|
  f.price 100
end

Factory.define :capital_ship, :class => CapitalShip, :parent => :unit do |f|
  f.price 500
end

Factory.define :trooper, :class => Trooper, :parent => :unit do |f|
  f.price 10
  f.hyperdrive false
end

Factory.define :light_transport, :class => LightTransport, :parent => :unit do |f|
  f.price 100
end

Factory.define :armament, :class => Armament, :parent => :unit do |f|
  f.price 10
end

Factory.define :skill, :class => Skill, :parent => :unit do |f|
  f.price 500
end

Factory.define :warrior, :class => Warrior, :parent => :unit do |f|
  f.price 50
end

Factory.define :commander, :class => Commander, :parent => :unit do |f|
  f.price 800
end

Factory.define :miner, :class => Miner, :parent => :unit do |f|
  f.price 400
end

Factory.define :sensor, :class => Sensor, :parent => :unit do |f|
  f.price 1000
end


Factory.define :facility_fleet, :class => FacilityFleet, :parent => :generic_fleet do |f|
  f.facility {|a| a.association(:facility) }
  f.balance 0
  f.level 0
end

Factory.define :rebels, :parent => :squad do |f|
end

Factory.define :user do |f|
  f.email Forgery::Internet.email_address
  f.password Forgery::Basic.password
end

Factory.define :route do |f|
  f.vector_a {|a| a.association(:planet)}
  f.vector_b {|a| a.association(:planet)}
end

Factory.define :round do |f|
  f.number 1
end

Factory.define :result do |f|
  f.association :round
  f.association :planet
  f.association :squad
  f.association :generic_unit
  f.quantity 10
  f.final_quantity 0
  f.after_build do |f|
    f.generic_fleet = Factory :generic_fleet, :generic_unit => f.generic_unit, :planet => f.planet, :quantity => f.quantity
  end
end

Factory.define :tradeport do |f|
  f.association :generic_unit
  f.quantity 1
  f.negotiation_rate 50
end

Factory.define :goal do |f|
  f.description Forgery::Name.full_name
end

Factory.define :setting do |f|
  f.initial_factories 1200
  f.initial_capital_ships 1700
  f.initial_fighters 2000
  f.initial_transports 400
  f.initial_troopers 1000
  f.initial_planets 2
  f.initial_credits 1000
  f.net_planet_income 500
  f.bonus_planet_income 1000
  f.ground_income_rate 60
  f.facility_divisor_rate 3
  f.facility_primary_production_rate 25
  f.facility_secondary_production_rate 10
  f.facility_upgrade_cost 1000
  f.facility_upgrade_rate 400
  f.capital_ship_upgrade_cost 1000
  f.maximum_warrior_life 10
  f.upgradable_capital_ships true
  f.editable_automatic_results false
  f.maximum_fleet_size 2000
  f.tradeports true
  f.maximum_facilities 1
  f.air_domination_unit 'CapitalShip'
  f.ground_domination_unit 'Trooper'
  f.builder_unit 'Trooper'
end

