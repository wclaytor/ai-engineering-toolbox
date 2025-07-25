module Toolbox
  class Database
    def self.setup
      ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3',
        database: Toolbox.database_path
      )
      
      # Create tables if they don't exist
      create_tables unless tables_exist?
    end
    
    private
    
    def self.tables_exist?
      ActiveRecord::Base.connection.table_exists?('categories') &&
      ActiveRecord::Base.connection.table_exists?('projects') &&
      ActiveRecord::Base.connection.table_exists?('metadata')
    end
    
    def self.create_tables
      ActiveRecord::Schema.define do
        create_table :categories, if_not_exists: true do |t|
          t.string :name, null: false
          t.string :slug, null: false
          t.text :description
          t.integer :sort_order, default: 0
          t.timestamps
        end
        
        create_table :projects, if_not_exists: true do |t|
          t.references :category, null: false, foreign_key: true
          t.string :name, null: false
          t.string :url, null: false
          t.text :description, null: false
          t.text :features  # JSON serialized
          t.integer :sort_order, default: 0
          t.timestamps
        end
        
        create_table :metadata, if_not_exists: true do |t|
          t.string :key, null: false
          t.text :value
          t.timestamps
        end
        
        add_index :categories, :slug, unique: true, if_not_exists: true
        add_index :projects, :category_id, if_not_exists: true
        add_index :metadata, :key, unique: true, if_not_exists: true
      end
    end
  end
end