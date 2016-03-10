class AddRoundToGenericFleets < ActiveRecord::Migration
  def self.up
    add_column :generic_fleets, :round, :integer
  end

  def self.down
    remove_column :generic_fleets, :round
  end
end
