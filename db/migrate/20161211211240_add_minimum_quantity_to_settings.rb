class AddMinimumQuantityToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :minimum_quantity, :integer
  end

  def self.down
    remove_column :settings, :minimum_quantity
  end
end
