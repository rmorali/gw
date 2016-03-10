class AddInitialPlanetsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :initial_planets, :integer
  end

  def self.down
    remove_column :settings, :initial_planets
  end
end
