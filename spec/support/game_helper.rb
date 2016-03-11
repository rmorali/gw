module GameHelper
  def start_game
    login_user!
    @squad = Factory :squad
    @user.squad = @squad
    4.times { Factory :planet, :sector => 1 }
    4.times { Factory :planet, :sector => 2 }
    4.times { Factory :planet, :sector => 3 }
    4.times { Factory :planet, :sector => 4 }
    Planet.disable_routes
    Factory :goal
    Factory :armament, :factions => 'empire'
    Factory :trooper, :factions => 'empire'
    Factory :light_transport, :factions => 'empire'
    Factory :warrior, :factions => 'empire'
    Factory :warrior, :factions => 'empire', :price => 40
    Factory :warrior, :factions => 'empire', :price => 45
    Factory :commander, :factions => 'empire'
    Factory :commander, :factions => 'empire', :price => 1000
    Factory :fighter, :factions => 'empire'
    Factory :capital_ship, :factions => 'empire'
    Factory :facility, :price => 1200, :factions => 'empire'
    Factory :facility, :price => 2400, :factions => 'empire'
    Round.getInstance.new_game!
    visit '/fleets'
  end
end
