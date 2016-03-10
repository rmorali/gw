class AddMovingToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :moving, :boolean
  end

  def self.down
    remove_column :results, :moving
  end
end
