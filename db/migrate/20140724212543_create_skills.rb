class CreateSkills < ActiveRecord::Migration
  def self.up
    create_table :skills do |t|
      t.integer :price
      t.string :name
      t.string :description
    end
  end

  def self.down
    drop_table :skills
  end
end
