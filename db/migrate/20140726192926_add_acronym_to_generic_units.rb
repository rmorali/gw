class AddAcronymToGenericUnits < ActiveRecord::Migration
  def self.up
    add_column :generic_units, :acronym, :string
  end

  def self.down
    remove_column :generic_units, :acronym
  end
end
