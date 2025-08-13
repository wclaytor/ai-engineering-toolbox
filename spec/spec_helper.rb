require "bundler/setup"
require "rspec"
require "factory_bot"
require "database_cleaner"

# Load the main library
require_relative "../lib/toolbox"

RSpec.configure do |config|
  # Use the expect syntax
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Use the mock framework
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Configure FactoryBot
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  # Configure DatabaseCleaner for tests that need database
  config.before(:each, :database) do
    # Set up test database for database tests
    test_db_path = File.join(File.dirname(__dir__), "test_toolbox.db")

    # Establish test database connection
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: test_db_path
    )

    # Set up database schema
    Toolbox::Database.setup

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each, :database) do
    DatabaseCleaner.clean

    # Clean up test database
    test_db_path = File.join(File.dirname(__dir__), "test_toolbox.db")
    File.delete(test_db_path) if File.exist?(test_db_path)
  end

  # Show the slowest examples
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies
  config.order = :random
  Kernel.srand config.seed

  # Filter specs by metadata
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
