class AddAiLevelToSquads < ActiveRecord::Migration
  def self.up
    add_column :squads, :ai_level, :integer
  end

  def self.down
    remove_column :squads, :ai_level
  end

end
