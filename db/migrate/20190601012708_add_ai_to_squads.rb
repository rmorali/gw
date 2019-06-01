class AddAiToSquads < ActiveRecord::Migration
  def self.up
    add_column :squads, :ai, :boolean
  end

  def self.down
    remove_column :squads, :ai
  end
end
