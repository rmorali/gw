class AddTradeportsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :tradeports, :boolean
  end

  def self.down
    remove_column :settings, :tradeports
  end
end
