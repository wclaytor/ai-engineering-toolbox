module Toolbox
  # Database management utilities for the AI Engineering Toolbox
  # Handles SQLite connection setup, migration checks, and database initialization
  class Database
    # Required tables for a properly migrated database
    REQUIRED_TABLES = %w[categories projects metadata schema_migrations].freeze

    # Establishes database connection and validates migration status
    # @return [Boolean] true if setup successful, false otherwise
    def self.setup
      ActiveRecord::Base.establish_connection(
        adapter: "sqlite3",
        database: Toolbox.database_path
      )

      return true if migrated?

      puts "Database not migrated. Run 'rake db:migrate' to set up the database."
      false
    end

    # Checks if the database has been properly migrated
    # @return [Boolean] true if all required tables exist
    def self.migrated?
      return false unless File.exist?(Toolbox.database_path)

      connection = ActiveRecord::Base.connection
      REQUIRED_TABLES.all? { |table| connection.table_exists?(table) }
    end

    # Executes database migrations
    # @return [Boolean] migration command success status
    def self.migrate!
      system("rake db:migrate")
    end
  end
end
