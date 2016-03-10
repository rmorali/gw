class AddInitialFightersToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :initial_fighters, :integer
  end

  def self.down
    remove_column :settings, :initial_fighters
  end
end
