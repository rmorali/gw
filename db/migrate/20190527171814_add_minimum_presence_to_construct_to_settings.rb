class AddMinimumPresenceToConstructToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :minimum_presence_to_construct, :integer
  end

  def self.down
    remove_column :settings, :minimum_presence_to_construct
  end
end
