class AddSubtypeIdToGenericUnits < ActiveRecord::Migration
  def self.up
    add_column :generic_units, :subtype_id, :integer
  end

  def self.down
    remove_column :generic_units, :subtype_id
  end
end
