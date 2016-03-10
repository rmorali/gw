class AddNotLandedToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :not_landed, :integer
  end

  def self.down
    remove_column :results, :not_landed
  end
end
