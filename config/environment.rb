# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Rpg::Application.initialize!

# Set MySQL to clear sql mode for all connections
# http://stackoverflow.com/a/21615180/151007
class ActiveRecord::ConnectionAdapters::MysqlAdapter 
  alias :connect_no_sql_mode :connect
  def connect
    connect_no_sql_mode
    execute("SET sql_mode = ''")
  end
end

ActiveRecord::Base.connection.reconnect!
