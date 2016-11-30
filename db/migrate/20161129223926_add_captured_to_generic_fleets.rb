class AddCapturedToGenericFleets < ActiveRecord::Migration
  def self.up
    add_column :generic_fleets, :captured, :boolean
  end

  def self.down
    remove_column :generic_fleets, :captured
  end
end
