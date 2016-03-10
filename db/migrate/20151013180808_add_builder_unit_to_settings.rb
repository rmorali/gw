class AddBuilderUnitToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :builder_unit, :string
  end

  def self.down
    remove_column :settings, :builder_unit
  end
end
