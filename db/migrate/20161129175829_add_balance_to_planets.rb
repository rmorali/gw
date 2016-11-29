class AddBalanceToPlanets < ActiveRecord::Migration
  def self.up
    add_column :planets, :balance, :integer
  end

  def self.down
    remove_column :planets, :balance
  end
end
