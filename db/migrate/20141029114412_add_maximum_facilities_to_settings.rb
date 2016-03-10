class AddMaximumFacilitiesToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :maximum_facilities, :integer
  end

  def self.down
    remove_column :settings, :maximum_facilities
  end
end
