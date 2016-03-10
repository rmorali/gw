class CreateSubtypes < ActiveRecord::Migration
  def self.up
    create_table :subtypes do |t|
      t.string :name
      t.string :description
    end
  end

  def self.down
    drop_table :subtypes
  end
end
