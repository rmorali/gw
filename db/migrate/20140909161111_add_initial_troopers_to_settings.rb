class AddInitialTroopersToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :initial_troopers, :integer
  end

  def self.down
    remove_column :settings, :initial_troopers
  end
end
