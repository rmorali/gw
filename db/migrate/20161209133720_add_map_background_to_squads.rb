class AddMapBackgroundToSquads < ActiveRecord::Migration
  def self.up
    add_column :squads, :map_background, :boolean
  end

  def self.down
    remove_column :squads, :map_background
  end
end
