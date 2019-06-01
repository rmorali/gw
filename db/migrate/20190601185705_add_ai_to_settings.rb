class AddAiToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :ai, :boolean
  end

  def self.down
    remove_column :settings, :ai
  end
end
