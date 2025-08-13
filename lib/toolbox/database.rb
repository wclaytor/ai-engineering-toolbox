module Toolbox
  class Database
    def self.setup
      ActiveRecord::Base.establish_connection(
        adapter: "sqlite3",
        database: Toolbox.database_path
      )

      # Check if database has been migrated
      unless migrated?
        puts "Database not migrated. Run 'rake db:migrate' to set up the database."
        return false
      end

      true
    end

    def self.migrated?
      return false unless File.exist?(Toolbox.database_path)

      ActiveRecord::Base.connection.table_exists?("categories") &&
      ActiveRecord::Base.connection.table_exists?("projects") &&
      ActiveRecord::Base.connection.table_exists?("metadata") &&
      ActiveRecord::Base.connection.table_exists?("schema_migrations")
    end

    def self.migrate!
      system("rake db:migrate")
    end
  end
end
