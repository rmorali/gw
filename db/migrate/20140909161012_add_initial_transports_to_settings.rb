class AddInitialTransportsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :initial_transports, :integer
  end

  def self.down
    remove_column :settings, :initial_transports
  end
end
