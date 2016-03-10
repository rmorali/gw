class AddInitialCreditsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :initial_credits, :integer
  end

  def self.down
    remove_column :settings, :initial_credits
  end
end
