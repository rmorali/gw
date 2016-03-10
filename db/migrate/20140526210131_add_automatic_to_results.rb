class AddAutomaticToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :automatic, :boolean
  end

  def self.down
    remove_column :results, :automatic
  end
end
