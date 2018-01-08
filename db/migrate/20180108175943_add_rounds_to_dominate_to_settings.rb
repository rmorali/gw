class AddRoundsToDominateToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :rounds_to_dominate, :integer
  end

  def self.down
    remove_column :settings, :rounds_to_dominate
  end
end
