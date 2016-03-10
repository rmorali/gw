class AddInitialFactoriesToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :initial_factories, :integer
  end

  def self.down
    remove_column :settings, :initial_factories
  end
end
