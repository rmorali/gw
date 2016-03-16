bespin = Planet.create(:name => 'Bespin', :sector => 1, :credits => 500, :description => 'Bespin Cloud City' )
brr_station = Planet.create(:name => 'BrR Station', :sector => 4, :credits => 0, :tradeport => true, :description => 'Tradeport' )
cimf_station = Planet.create(:name => 'CIMF Station', :sector => 1, :credits => 0, :tradeport => true, :description => 'Tradeport' )
concord_dawn = Planet.create(:name => 'Concord Dawn', :sector => 2, :credits => 500, :description => 'Raxus Prime' )
corellia = Planet.create(:name => 'Corellia', :sector => 2, :credits => 500, :description => 'Corellia', :file_name => 'dagobah.gif', :coord_x => 8, :coord_y => 3 )
coruscant = Planet.create(:name => 'Coruscant', :sector => 2, :credits => 500, :description => 'Coruscant' )
dagobah = Planet.create(:name => 'Dagobah', :sector => 4, :credits => 500, :description => 'Dagobah' )
deathstar = Planet.create(:name => 'Death Star', :sector => 2, :credits => 500, :description => 'Deathstar', :file_name => 'death_star.png', :coord_x => 5, :coord_y => 2 )
endor = Planet.create(:name => 'Endor', :sector => 1, :credits => 500, :description => 'Kashyyyk' )
felucia = Planet.create(:name => 'Felucia', :sector => 3, :credits => 500, :description => 'Felucia' )
geonosis = Planet.create(:name => 'Geonosis', :sector => 4, :credits => 500, :description => 'Geonosis/R. Prime' )
haruun_kal = Planet.create(:name => 'Haruun Kal', :sector => 4, :credits => 500, :description => 'Haruun Kal' )
hoth = Planet.create(:name => 'Hoth', :sector => 1, :credits => 500, :description => 'Hoth/RhenVar Harbor' )
kamino = Planet.create(:name => 'Kamino', :sector => 3, :credits => 500, :description => 'Kamino' )
kashyyyk = Planet.create(:name => 'Kashyyyk', :sector => 3, :credits => 500, :description => 'Kashyyyk' )
kessel_asteroids = Planet.create(:name => 'Kessel Asteroids', :sector => 3, :credits => 500, :description => 'Polis Massa' )
kuat = Planet.create(:name => 'Kuat', :sector => 4, :credits => 500, :description => 'Ord Ibanna', :file_name => 'eriadu.gif', :coord_x => 9, :coord_y => 4 )
mandalore = Planet.create(:name => 'Mandalore', :sector => 2, :credits => 500, :description => 'Yavin Arena', :file_name => 'eriadu.gif', :coord_x => 6, :coord_y => 3 )
mon_calamari = Planet.create(:name => 'Mon Calamari', :sector => 3, :credits => 500, :description => 'Kamino Tipoca City' )
mustafar = Planet.create(:name => 'Mustafar', :sector => 1, :credits => 500, :description => 'Mustafar' )
mygeeto = Planet.create(:name => 'Mygeeto', :sector => 2, :credits => 500, :description => 'Mygeeto' )
naboo = Planet.create(:name => 'Naboo', :sector => 4, :credits => 500, :description => 'Naboo' )
nal_hutta = Planet.create(:name => 'Nal Hutta', :sector => 3, :credits => 500, :description => 'Jabba Palace' )
ord_ibanna = Planet.create(:name => 'Ord Ibanna', :sector => 1, :credits => 500, :description => 'Ord Ibanna' )
polis_massa = Planet.create(:name => 'Polis Massa', :sector => 1, :credits => 500, :description => 'Polis Massa' )
rattatak = Planet.create(:name => 'Rattatak', :sector => 1, :credits => 500, :description => 'Rattatak' )
res_station = Planet.create(:name => 'RES Station', :sector => 3, :credits => 0, :tradeport => true, :description => 'Tradeport' )
rhen_var = Planet.create(:name => 'Rhen Var', :sector => 3, :credits => 500, :description => 'Rhen Var Citadel' )
tatooine = Planet.create(:name => 'Tatooine', :sector => 4, :credits => 500, :description => 'Mos Eisley' )
utapau = Planet.create(:name => 'Utapau', :sector => 4, :credits => 500, :description => 'Utapau' )
yavin = Planet.create(:name => 'Yavin', :sector => 2, :credits => 500, :description => 'Yavin 4' )

Route.create(:vector_a => mygeeto, :vector_b => yavin, :distance => 1)
Route.create(:vector_a => mygeeto, :vector_b => deathstar, :distance => 1)
Route.create(:vector_a => mygeeto, :vector_b => coruscant, :distance => 1)
Route.create(:vector_a => yavin, :vector_b => rhen_var, :distance => 1)
Route.create(:vector_a => yavin, :vector_b => deathstar, :distance => 1)
Route.create(:vector_a => yavin, :vector_b => concord_dawn, :distance => 1)
Route.create(:vector_a => rhen_var, :vector_b => felucia, :distance => 1)
Route.create(:vector_a => rhen_var, :vector_b => concord_dawn, :distance => 1)
Route.create(:vector_a => deathstar, :vector_b => coruscant, :distance => 1)
Route.create(:vector_a => coruscant, :vector_b => mandalore, :distance => 1)
Route.create(:vector_a => coruscant, :vector_b => bespin, :distance => 1)
Route.create(:vector_a => corellia, :vector_b => concord_dawn, :distance => 1)
Route.create(:vector_a => corellia, :vector_b => kuat, :distance => 1)
Route.create(:vector_a => mandalore, :vector_b => corellia, :distance => 1)
Route.create(:vector_a => mandalore, :vector_b => deathstar, :distance => 1)
Route.create(:vector_a => concord_dawn, :vector_b => felucia, :distance => 1)
Route.create(:vector_a => concord_dawn, :vector_b => kessel_asteroids, :distance => 1)
Route.create(:vector_a => concord_dawn, :vector_b => deathstar, :distance => 1)
Route.create(:vector_a => felucia, :vector_b => mon_calamari, :distance => 1)
Route.create(:vector_a => felucia, :vector_b => kashyyyk, :distance => 1)
Route.create(:vector_a => felucia, :vector_b => kessel_asteroids, :distance => 1)
Route.create(:vector_a => mon_calamari, :vector_b => res_station, :distance => 1)
Route.create(:vector_a => mon_calamari, :vector_b => kashyyyk, :distance => 1)
Route.create(:vector_a => endor, :vector_b => bespin, :distance => 1)
Route.create(:vector_a => endor, :vector_b => hoth, :distance => 1)
Route.create(:vector_a => endor, :vector_b => rattatak, :distance => 1)
Route.create(:vector_a => endor, :vector_b => ord_ibanna, :distance => 1)
Route.create(:vector_a => endor, :vector_b => polis_massa, :distance => 1)
Route.create(:vector_a => rattatak, :vector_b => polis_massa, :distance => 1)
Route.create(:vector_a => bespin, :vector_b => rattatak, :distance => 1)
Route.create(:vector_a => bespin, :vector_b => mandalore, :distance => 1)
Route.create(:vector_a => bespin, :vector_b => hoth, :distance => 1)
Route.create(:vector_a => corellia, :vector_b => deathstar, :distance => 1)
Route.create(:vector_a => corellia, :vector_b => haruun_kal, :distance => 1)
Route.create(:vector_a => kuat, :vector_b => kessel_asteroids, :distance => 1)
Route.create(:vector_a => kessel_asteroids, :vector_b => kashyyyk, :distance => 1)
Route.create(:vector_a => kessel_asteroids, :vector_b => nal_hutta, :distance => 1)
Route.create(:vector_a => kessel_asteroids, :vector_b => corellia, :distance => 1)
Route.create(:vector_a => kashyyyk, :vector_b => res_station, :distance => 1)
Route.create(:vector_a => kashyyyk, :vector_b => kamino, :distance => 1)
Route.create(:vector_a => kashyyyk, :vector_b => nal_hutta, :distance => 1)
Route.create(:vector_a => cimf_station, :vector_b => rattatak, :distance => 1)
Route.create(:vector_a => cimf_station, :vector_b => coruscant, :distance => 1)
Route.create(:vector_a => cimf_station, :vector_b => bespin, :distance => 1)
Route.create(:vector_a => hoth, :vector_b => haruun_kal, :distance => 1)
Route.create(:vector_a => hoth, :vector_b => ord_ibanna, :distance => 1)
Route.create(:vector_a => hoth, :vector_b => mandalore, :distance => 1)
Route.create(:vector_a => hoth, :vector_b => naboo, :distance => 1)
Route.create(:vector_a => haruun_kal, :vector_b => naboo, :distance => 1)
Route.create(:vector_a => haruun_kal, :vector_b => mandalore, :distance => 1)
Route.create(:vector_a => haruun_kal, :vector_b => geonosis, :distance => 1)
Route.create(:vector_a => haruun_kal, :vector_b => kuat, :distance => 1)
Route.create(:vector_a => kuat, :vector_b => nal_hutta, :distance => 1)
Route.create(:vector_a => kuat, :vector_b => tatooine, :distance => 1)
Route.create(:vector_a => kuat, :vector_b => geonosis, :distance => 1)
Route.create(:vector_a => nal_hutta, :vector_b => kamino, :distance => 1)
Route.create(:vector_a => nal_hutta, :vector_b => tatooine, :distance => 1)
Route.create(:vector_a => res_station, :vector_b => kamino, :distance => 1)
Route.create(:vector_a => mustafar, :vector_b => endor, :distance => 1)
Route.create(:vector_a => mustafar, :vector_b => polis_massa, :distance => 1)
Route.create(:vector_a => mustafar, :vector_b => ord_ibanna, :distance => 1)
Route.create(:vector_a => ord_ibanna, :vector_b => naboo, :distance => 1)
Route.create(:vector_a => ord_ibanna, :vector_b => dagobah, :distance => 1)
Route.create(:vector_a => naboo, :vector_b => geonosis, :distance => 1)
Route.create(:vector_a => naboo, :vector_b => utapau, :distance => 1)
Route.create(:vector_a => naboo, :vector_b => dagobah, :distance => 1)
Route.create(:vector_a => geonosis, :vector_b => tatooine, :distance => 1)
Route.create(:vector_a => geonosis, :vector_b => brr_station, :distance => 1)
Route.create(:vector_a => geonosis, :vector_b => utapau, :distance => 1)
Route.create(:vector_a => dagobah, :vector_b => utapau, :distance => 1)
Route.create(:vector_a => utapau, :vector_b => brr_station, :distance => 1)
Route.create(:vector_a => brr_station, :vector_b => tatooine, :distance => 1)

Goal.create(:description => 'Dominar o Quadrante Norte e o planeta Dagobah')
Goal.create(:description => 'Dominar o Quadrante Norte e o planeta Kamino')
Goal.create(:description => 'Dominar o Quadrante Sul e o planeta Mygeeto')
Goal.create(:description => 'Dominar o Quadrante Sul e o planeta Polis Massa')
Goal.create(:description => 'Dominar o Quadrante Oeste e o planeta Nal Hutta')
Goal.create(:description => 'Dominar o Quadrante Leste e o planeta Hoth')
Goal.create(:description => 'Dominar os 4 planetas com Income Especial')

Setting.create(:initial_factories => 2400,
               :initial_fighters => 0,
               :initial_capital_ships => 0,
               :initial_transports => 0,
               :initial_troopers => 0,
               :initial_planets => 1,
               :initial_credits => 1000,
               :net_planet_income => 500,
               :bonus_planet_income => 1000,
               :ground_income_rate => 50,
               :facility_divisor_rate => 4,
               :facility_primary_production_rate => 50,
               :facility_secondary_production_rate => 10,
               :facility_upgrade_cost => 1200,
               :facility_upgrade_rate => 300,
               :capital_ship_upgrade_cost => 1000,
               :maximum_warrior_life => 10,
               :upgradable_capital_ships => true,
               :editable_automatic_results => false,
               :maximum_fleet_size => 1000,
               :tradeports => true,
               :maximum_facilities => 4,
               :air_domination_unit => 'CapitalShip',
               :ground_domination_unit => 'Facility',
               :builder_unit => 'LightTransport')

User.create(:email => 'setup@xws.com', :password => '123456')

imp = ['empire']
reb = ['rebel']
imp_reb = ['empire','rebel']
merc = ['mercenary']
merc_reb = ['mercenary','rebel']
mand = ['pirate']
mand_merc = ['pirate','mercenary']
all = ['empire','rebel','mercenary','pirate']
none = ['nenhuma']

Facility.create(:name => 'Ind.Complex', :price => 1200, :description => 'Comboio(6 Bulk Freighter)' ).factions = imp_reb
Facility.create(:name => 'Space Colony', :price => 1200, :description => 'Comboio(6 Cargo Ferry)' ).factions = mand_merc
Facility.create(:name => 'Cargo Facility II', :price => 1800, :description => 'Comboio(6 Mod.Conveyor)' ).factions = mand_merc
Facility.create(:name => 'Platforms', :price => 1800, :description => 'Comboio(6 Mod.Action Transp)' ).factions = all
Facility.create(:name => 'DeepSpace Facility', :price => 1800, :description => 'Comboio(6 Mod.Action Transp)' ).factions = all
Facility.create(:name => 'Asteroid Hangar', :price => 2400, :description => 'Comboio(6 Xyitiar Transp)' ).factions = all
Facility.create(:name => 'Rebel Platform', :price => 2400, :description => 'Comboio(6 Reb Med Transp)' ).factions = reb
Facility.create(:name => 'Golan I', :price => 2400, :description => 'Comboio(6 Mod Action Transp)' ).factions = all
Facility.create(:name => 'Golan II', :price => 3000, :description => 'Comboio(6 Container Transp)' ).factions = all
Facility.create(:name => 'Imp Research Ship', :price => 3000, :description => 'Comboio(6 Star Galleon)' ).factions = imp
Facility.create(:name => 'Pirate S.Yard', :price => 3000, :description => 'Comboio(6 Xyitiar Transp)' ).factions = mand_merc
Facility.create(:name => 'Golan III', :price => 3600, :description => 'Comboio(6 Xyitiar Transp)' ).factions = all
Facility.create(:name => 'Shipyard', :price => 3600, :description => 'Comboio(6 Xyitiar Transp)' ).factions = all

Unit.create(:name => '__________Capital Ships__________').factions = all
CapitalShip.create(:name => 'Corellian Gunship', :price => 300, :description => 'Bonus +1 nave simultanea no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = all
CapitalShip.create(:name => 'Corellian Corvette', :price => 300, :description => 'Bonus +1 nave simultanea no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = all
CapitalShip.create(:name => 'Mod Corvette', :price => 300, :description => 'Bonus +1 nave simultanea no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = mand_merc
CapitalShip.create(:name => 'Nebulon B Frigate', :price => 350, :description => 'Bonus +1 nave simultanea no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = all
CapitalShip.create(:name => 'Mod Nebulon Frigate', :price => 500, :description => 'Bonus +1 nave simultanea no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = all
CapitalShip.create(:name => 'Carrack Cruiser', :price => 350, :description => 'Bonus +1 nave simultanea no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = imp
CapitalShip.create(:name => 'Lancer Frigate', :price => 400, :description => 'Bonus +1 nave simultanea no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = imp
CapitalShip.create(:name => 'Marauder Corvette', :price => 600, :description => 'Bonus +1 nave simultanea no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = mand_merc
CapitalShip.create(:name => 'Dreadnaught', :price => 900, :description => 'Bonus +2 naves simultaneas no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = mand_merc
CapitalShip.create(:name => 'Escort Carrier', :price => 650, :description => 'Bonus +2 naves simultaneas no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = imp
CapitalShip.create(:name => 'MC40A Light Cruiser', :price => 650, :description => 'Bonus +2 naves simultaneas no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = reb
CapitalShip.create(:name => 'Bulk Cruiser', :price => 720, :description => 'Bonus +2 naves simultaneas no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = mand_merc
CapitalShip.create(:name => 'Mod Strike Cruiser', :price => 1150, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = mand_merc
CapitalShip.create(:name => 'Strike Cruiser', :price => 800, :description => 'Bonus +2 naves simultaneas no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = imp_reb
CapitalShip.create(:name => 'Assault Frigate', :price => 1150, :description => 'Bonus +2 naves simultaneas no XWA', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = reb
CapitalShip.create(:name => 'MC80A Chatnoir Cruiser', :price => 1250, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = mand_merc
CapitalShip.create(:name => 'MC80 Reefhome Cruiser', :price => 1450, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = reb
CapitalShip.create(:name => 'Victory SD', :price => 1350, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = imp
CapitalShip.create(:name => 'MC80 Liberty Cruiser', :price => 1450, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = reb
CapitalShip.create(:name => 'MC85A Home One Cruiser', :price => 5000, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = reb
CapitalShip.create(:name => 'Victory SD II', :price => 1500, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = imp
CapitalShip.create(:name => 'Interdictor', :price => 2250, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = imp
CapitalShip.create(:name => 'Imperial SD', :price => 1800, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = imp
CapitalShip.create(:name => 'Imperial SD II', :price => 2000, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = imp
CapitalShip.create(:name => 'Super Star Destroyer', :price => 6000, :description => 'Bonus +2 naves +1 transporte simultaneos', :heavy_loading_capacity => 100, :light_loading_capacity => 1000 ).factions = imp

Unit.create(:name => '__________Light Transports_______').factions = all
LightTransport.create(:name => 'YT-1300', :price => 80, :heavy_loading_capacity => 4, :light_loading_capacity => 200 ).factions = merc
LightTransport.create(:name => 'YT-2000', :price => 175, :heavy_loading_capacity => 4, :light_loading_capacity => 200 ).factions = merc
LightTransport.create(:name => 'YT-2400', :price => 125, :heavy_loading_capacity => 4, :light_loading_capacity => 200 ).factions = mand
LightTransport.create(:name => 'Millenium Falcon', :price => 150, :heavy_loading_capacity => 4, :light_loading_capacity => 200 ).factions = merc_reb
LightTransport.create(:name => 'Assault Transport', :price => 100, :heavy_loading_capacity => 4, :light_loading_capacity => 200 ).factions = all
LightTransport.create(:name => 'Escort Transport', :price => 100, :heavy_loading_capacity => 4, :light_loading_capacity => 200 ).factions = reb
LightTransport.create(:name => 'Assault Shuttle', :price => 100, :heavy_loading_capacity => 4, :light_loading_capacity => 200 ).factions = imp
LightTransport.create(:name => 'System Pat Craft', :price => 150, :heavy_loading_capacity => 4, :light_loading_capacity => 200 ).factions = imp

Unit.create(:name => '__________Fighters_____________').factions = all
Fighter.create(:name => 'Z-95', :price => 35 ).factions = merc_reb
Fighter.create(:name => 'Y-Wing', :price => 70 ).factions = reb
Fighter.create(:name => 'X-Wing', :price => 80 ).factions = reb
Fighter.create(:name => 'A-Wing', :price => 110 ).factions = reb
Fighter.create(:name => 'B-Wing', :price => 145 ).factions = reb
Fighter.create(:name => 'Pinook Fighter', :price => 35 ).factions = merc
Fighter.create(:name => 'Clockshape Fighter', :price => 55 ).factions = merc
Fighter.create(:name => 'Planetary Fighter', :price => 55 ).factions = merc
Fighter.create(:name => 'R-41 Starchaser', :price => 65 ).factions = merc
Fighter.create(:name => 'Razor Fighter', :price => 70 ).factions = merc
Fighter.create(:name => 'Skipray Blastboat', :price => 105 ).factions = merc
Fighter.create(:name => 'T-Wing', :price => 35 ).factions = mand
Fighter.create(:name => 'Preybird Fighter', :price => 50 ).factions = mand
Fighter.create(:name => 'Supa Fighter', :price => 70 ).factions = mand
Fighter.create(:name => 'Pursuer', :price => 80 ).factions = mand
Fighter.create(:name => 'Firespray', :price => 95 ).factions = mand
Fighter.create(:name => 'Tie Fighter*', :hyperdrive => false, :price => 20, :description => 'Sem Hyperdrive/Warheads' ).factions = imp
Fighter.create(:name => 'Tie Bomber*', :hyperdrive => false, :price => 25, :description => 'Sem Hyperdrive' ).factions = imp
Fighter.create(:name => 'Tie Interceptor*', :hyperdrive => false, :price => 30, :description => 'Sem Hyperdrive/Warheads' ).factions = imp
Fighter.create(:name => 'Authority IRD*', :hyperdrive => false, :price => 45, :description => 'Sem Hyperdrive' ).factions = none
Fighter.create(:name => 'Toscan Fighter', :price => 90 ).factions = none
Fighter.create(:name => 'Tie Avenger', :price => 110 ).factions = imp
Fighter.create(:name => 'Assault Gunboat', :price => 120 ).factions = imp
Fighter.create(:name => 'Missile Boat', :price => 200 ).factions = imp
Fighter.create(:name => 'Tie Defender', :price => 300 ).factions = imp

Unit.create(:name => '_________Armamentos_____________').factions = all
Armament.create(:name => 'Missile', :acronym => 'M', :price => 5, :hyperdrive => false ).factions = all
Armament.create(:name => 'Proton Torpedo', :acronym => 'PT', :price => 5, :hyperdrive => false ).factions = all
Armament.create(:name => 'Ion Pulse Torp', :acronym => 'IonPT', :price => 5, :hyperdrive => false ).factions = reb
Armament.create(:name => 'Adv Missile', :acronym => 'AdvM', :price => 10, :hyperdrive => false ).factions = all
Armament.create(:name => 'Adv Torpedo', :acronym => 'AdvT', :price => 10, :hyperdrive => false ).factions = all
Armament.create(:name => 'Mag Pulse Torp', :acronym => 'MagPT', :price => 10, :hyperdrive => false ).factions = all
Armament.create(:name => 'Heavy Rocket', :acronym => 'HR', :price => 15, :hyperdrive => false ).factions = all
Armament.create(:name => 'Space Bomb', :acronym => 'SB', :price => 20, :hyperdrive => false ).factions = all
Armament.create(:name => 'Chaff', :acronym => 'CHF', :price => 2, :hyperdrive => false ).factions = all
Armament.create(:name => 'Flare', :acronym => 'FLR', :price => 10, :hyperdrive => false ).factions = all

Unit.create(:name => '_____Capital Ship Skills________').factions = all
Skill.create(:name => 'Sensor Array', :acronym => 'SAR', :price => 150, :hyperdrive => false, :description => 'Detecta Unidades Inimigas'  ).factions = all
#Skill.create(:name => 'Anti-Trooper Bombs', :acronym => 'ATB', :price => 150, :hyperdrive => false, :description => 'Bombardeia Exercitos'  ).factions = all
Skill.create(:name => 'Long Range Engine', :acronym => 'ENG', :price => 300, :hyperdrive => false, :description => 'Permite Hyperspace em todo o Setor'  ).factions = all
Skill.create(:name => 'Gravity Generator', :acronym => 'INT', :price => 600, :hyperdrive => false, :description => 'Bloqueia Fugas - Interdictor'  ).factions = all

#Unit.create(:name => '____________Tropas______________').factions = all
#Trooper.create(:name => 'BF2 Trooper', :price => 1, :hyperdrive => false ).factions = all

#Unit.create(:name => '__________Guerreiros_____________').factions = all
#Warrior.create(:name => 'Mestre Yoda', :price => 30, :description => 'Jedi' ).factions = reb
#Warrior.create(:name => 'Luke Skywalker', :price => 25, :description => 'Jedi' ).factions = reb
#Warrior.create(:name => 'Kyle Katarn', :price => 30, :description => 'Jedi' ).factions = none
#Warrior.create(:name => 'Kyp Durron', :price => 25, :description => 'Jedi' ).factions = none
#Warrior.create(:name => 'Darth Sidious', :price => 30, :description => 'Sith' ).factions = imp
#Warrior.create(:name => 'Darth Vader', :price => 25, :description => 'Sith' ).factions = imp
#Warrior.create(:name => 'Darth Tyranus', :price => 30, :description => 'Sith' ).factions = none
#Warrior.create(:name => 'Darth Maul', :price => 25, :description => 'Sith' ).factions = none
#Warrior.create(:name => 'Han Solo', :price => 30, :description => 'Mercenario' ).factions = merc
#Warrior.create(:name => 'Chewbacca', :price => 25, :description => 'Mercenario' ).factions = merc
#Warrior.create(:name => 'Boba Fett', :price => 30, :description => 'Pirata' ).factions = mand
#Warrior.create(:name => 'Ung Kusp', :price => 25, :description => 'Pirata' ).factions = mand


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
    
