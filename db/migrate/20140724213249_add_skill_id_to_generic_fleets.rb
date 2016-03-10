class AddSkillIdToGenericFleets < ActiveRecord::Migration
  def self.up
    add_column :generic_fleets, :skill_id, :integer
  end

  def self.down
    remove_column :generic_fleets, :skill_id
  end
end
