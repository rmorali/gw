class AddAcronymToSkills < ActiveRecord::Migration
  def self.up
    add_column :skills, :acronym, :string
  end

  def self.down
    remove_column :skills, :acronym
  end
end
