class ChangeColumnBalanceOnGenericFleet < ActiveRecord::Migration
  def self.up
    change_column :generic_fleets, :balance, :integer
  end

  def self.down
    change_column :generic_fleets, :balance, :integer
  end
end
