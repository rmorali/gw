class AddLeaderToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :leader, :boolean
  end

  def self.down
    remove_column :results, :leader
  end
end
