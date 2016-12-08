class AddMapRatioToSquads < ActiveRecord::Migration
  def self.up
    add_column :squads, :map_ratio, :integer
  end

  def self.down
    remove_column :squads, :map_ratio
  end
end
