class AddDescriptionToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :description, :string
  end

  def self.down
    remove_column :results, :description
  end
end
