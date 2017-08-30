class DropActiveAdminCommentsTable < ActiveRecord::Migration
=begin
  def self.up
    drop_table :active_admin_comments
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

=end
end
