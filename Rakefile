require "bundler/setup"
require "active_record"
require_relative "lib/toolbox"

# Database configuration
db_config = {
  adapter: "sqlite3",
  database: Toolbox.database_path
}

# Set up environment for database tasks
ENV["SCHEMA"] = "db/schema.rb"

# Database tasks
namespace :db do
  desc "Create the database"
  task :create do
    puts "Creating database at #{Toolbox.database_path}"
    # Database file will be created automatically by SQLite when first accessed
    puts "Database created successfully!"
  end

  desc "Drop the database"
  task :drop do
    if File.exist?(Toolbox.database_path)
      File.delete(Toolbox.database_path)
      puts "Database dropped successfully!"
    else
      puts "Database doesn't exist"
    end
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Migration.verbose = true

    # Create schema_migrations table manually if it doesn't exist
    unless ActiveRecord::Base.connection.table_exists?("schema_migrations")
      ActiveRecord::Base.connection.execute <<-SQL
        CREATE TABLE schema_migrations (
          version varchar(255) PRIMARY KEY
        );
      SQL
      puts "Created schema_migrations table"
    end

    # Create ar_internal_metadata table if it doesn't exist
    unless ActiveRecord::Base.connection.table_exists?("ar_internal_metadata")
      ActiveRecord::Base.connection.execute <<-SQL
        CREATE TABLE ar_internal_metadata (
          key varchar(255) PRIMARY KEY,
          value varchar(255),
          created_at datetime NOT NULL,
          updated_at datetime NOT NULL
        );
      SQL
      puts "Created ar_internal_metadata table"
    end

    # Load and run migrations manually
    migration_files = Dir["db/migrate/*.rb"].sort

    migration_files.each do |file|
      # Extract version from filename
      version = File.basename(file).split("_").first

      # Check if already migrated
      result = ActiveRecord::Base.connection.execute(
        "SELECT version FROM schema_migrations WHERE version = '#{version}'"
      ).first
      if result
        puts "Migration #{version} already applied, skipping"
        next
      end

      # Load and run the migration
      load file
      migration_class = File.basename(file, ".rb").split("_")[1..-1].map(&:capitalize).join
      migration = Object.const_get(migration_class).new

      puts "Running migration #{version}: #{migration_class}..."
      migration.migrate(:up)

      # Record the migration
      ActiveRecord::Base.connection.execute("INSERT INTO schema_migrations (version) VALUES ('#{version}')")

      puts "Migration #{version} completed successfully"
    end

    puts "Database migrated successfully!"
  end

  desc "Rollback the database"
  task :rollback do
    ActiveRecord::Base.establish_connection(db_config)

    migrations_paths = ["db/migrate"]
    context = ActiveRecord::MigrationContext.new(migrations_paths, ActiveRecord::SchemaMigration)

    context.rollback
    puts "Database rolled back successfully!"
  end

  desc "Reset the database"
  task :reset => [:drop, :create, :migrate]

  desc "Show migration version"
  task :version do
    ActiveRecord::Base.establish_connection(db_config)

    if ActiveRecord::Base.connection.table_exists?("schema_migrations")
      current_version = ActiveRecord::Base.connection.execute(
        "SELECT version FROM schema_migrations ORDER BY version DESC LIMIT 1"
      ).first
      if current_version
        puts "Current version: #{current_version['version']}"
      else
        puts "Current version: 0 (no migrations applied)"
      end
    else
      puts "Current version: 0 (schema_migrations table doesn't exist)"
    end
  end

  desc "Show migration status"
  task :status do
    ActiveRecord::Base.establish_connection(db_config)

    puts "\nMigration Status:"
    puts "=================="

    migration_files = Dir["db/migrate/*.rb"].sort

    if migration_files.empty?
      puts "No migrations found"
    else
      # Get all applied versions
      applied_versions = []
      if ActiveRecord::Base.connection.table_exists?("schema_migrations")
        applied_versions = ActiveRecord::Base.connection.execute("SELECT version FROM schema_migrations").map { |row| row["version"] }
      end

      migration_files.each do |file|
        version = File.basename(file).split("_").first
        migration_name = File.basename(file, ".rb").split("_")[1..-1].map(&:capitalize).join
        status = applied_versions.include?(version) ? "UP" : "DOWN"
        puts "#{status.ljust(4)} #{version} #{migration_name}"
      end
    end
  end
end

task :default => :'db:migrate'
