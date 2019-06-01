class AddAiLevelToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :ai_level, :integer
  end

  def self.down
    remove_column :settings, :ai_level
  end
end
