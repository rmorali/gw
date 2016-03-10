class DropSkillsTable < ActiveRecord::Migration
  def self.up
    drop_table :skills
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
