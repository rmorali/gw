class AddSkillIdToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :skill_id, :integer
  end

  def self.down
    remove_column :results, :skill_id
  end
end
