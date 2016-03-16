class AddFileNameToPlanets < ActiveRecord::Migration
  def self.up
    add_column :planets, :file_name, :string
  end

  def self.down
    remove_column :planets, :file_name
  end
end
