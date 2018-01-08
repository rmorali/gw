class AddPresenceToInfluenceToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :presence_to_influence, :integer
  end

  def self.down
    remove_column :settings, :presence_to_influence
  end
end
