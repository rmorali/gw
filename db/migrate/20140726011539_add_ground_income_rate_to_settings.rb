class AddGroundIncomeRateToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :ground_income_rate, :integer
  end

  def self.down
    remove_column :settings, :ground_income_rate
  end
end
