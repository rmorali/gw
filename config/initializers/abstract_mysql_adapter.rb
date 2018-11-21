=begin
ActiveSupport.on_load(:active_record) do
  class ActiveRecord::ConnectionAdapters::Mysql2Adapter
    NATIVE_DATABASE_TYPES[:primary_key] ="int(11) auto_increment PRIMARY KEY"
  end
end
=end
require 'active_record/connection_adapters/mysql_adapter'

class ActiveRecord::ConnectionAdapters::MysqlAdapter
  NATIVE_DATABASE_TYPES[:primary_key] = "int(11) auto_increment PRIMARY KEY"
end