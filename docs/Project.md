# AI Engineering Toolbox Automation Project

## Overview

This project automates the generation of the AI Engineering Toolbox README.md file from a SQLite database. Instead of manually maintaining the README, we maintain a structured database of tools and projects, then generate the README programmatically.

## Goals

- **Maintainability**: Separate content (data) from presentation (templates)
- **Consistency**: Ensure uniform formatting and structure across all entries
- **Scalability**: Easy to add new categories, projects, and metadata
- **Version Control**: Track changes to both data and generated output
- **Automation**: Generate README with a single command

## Architecture

### Database Schema

**SQLite Database**: `toolbox.db`

#### Tables

1. **categories**
   - `id` (INTEGER PRIMARY KEY)
   - `name` (TEXT) - Display name (e.g., "Application Development Frameworks")
   - `slug` (TEXT) - URL-friendly identifier (e.g., "application-development-frameworks")
   - `description` (TEXT) - Optional category description
   - `sort_order` (INTEGER) - Order in table of contents

2. **projects**
   - `id` (INTEGER PRIMARY KEY)
   - `category_id` (INTEGER) - Foreign key to categories
   - `name` (TEXT) - Project name
   - `url` (TEXT) - GitHub/project URL
   - `description` (TEXT) - Project description
   - `features` (TEXT) - JSON array of key features/bullet points
   - `sort_order` (INTEGER) - Order within category
   - `created_at` (TIMESTAMP)
   - `updated_at` (TIMESTAMP)

3. **metadata**
   - `key` (TEXT PRIMARY KEY)
   - `value` (TEXT)
   - Purpose: Store README header content, introduction text, etc.

### CLI Tool

**Command**: `toolbox` (Ruby CLI using Thor)

#### Commands

```bash
# Database operations
toolbox init                          # Initialize database with schema
toolbox migrate                       # Run database migrations

# Category management
toolbox category add "Category Name" --description="..." --order=10
toolbox category list
toolbox category update <id> --name="..." --order=5
toolbox category delete <id>

# Project management
toolbox project add --category="frameworks" --name="LangChain" \
  --url="https://github.com/langchain-ai/langchain" \
  --description="Framework for building LLM-powered applications" \
  --features='["Component chaining", "Third-party integrations"]'

toolbox project list [--category=<slug>]
toolbox project update <id> --name="..." --description="..."
toolbox project delete <id>

# Import/Export
toolbox import <file.json>            # Import projects from JSON
toolbox export [--format=json|csv]    # Export database

# Generation
toolbox generate                      # Generate README.md
toolbox generate --output=custom.md   # Generate to custom file
toolbox validate                      # Validate database integrity

# Utilities
toolbox stats                         # Show database statistics
toolbox search <term>                 # Search projects and descriptions
```

### Template System

**Template Engine**: ERB (Embedded Ruby)

**Template File**: `templates/readme.md.erb`

#### Template Structure
```erb
# AI Engineering Toolbox
<%= metadata['description'] %>

## Table of Contents
<% categories.each do |category| %>
- [<%= category.name %>](#<%= category.slug %>)
<% end %>

---

<% categories.each do |category| %>
## <%= category.name %>
<% if category.description %>
<%= category.description %>
<% end %>

<% category.projects.each do |project| %>
### <%= project.name %>
<%= project.url %>

#### Description
<%= project.description %>

<% if project.features && !project.features.empty? %>
<% project.features.each do |feature| %>
- <%= feature %>
<% end %>
<% end %>

<% end %>
<% end %>
```

## Implementation Plan

### Phase 1: Core Infrastructure
1. Create SQLite database schema using ActiveRecord migrations
2. Implement basic CLI with Thor
3. Add CRUD operations for categories and projects using ActiveRecord
4. Create simple ERB template for README generation

### Phase 2: Data Migration
1. Parse existing README.md to extract current projects
2. Create migration script to populate database
3. Validate generated output matches current README

### Phase 3: Enhanced Features
1. Add import/export functionality
2. Implement search and filtering
3. Add validation and integrity checks
4. Create backup/restore capabilities

### Phase 4: Automation & CI/CD
1. Add GitHub Actions workflow
2. Automatic README regeneration on database changes
3. Add linting and validation to CI pipeline

## File Structure

```
/workspaces/ai-engineering-toolbox/
├── Project.md                       # This file
├── README.md                        # Generated file (current manual version)
├── toolbox.db                       # SQLite database
├── Gemfile                          # Ruby dependencies
├── Gemfile.lock                     # Locked dependency versions
├── toolbox                          # Executable CLI script
├── lib/
│   ├── toolbox.rb                   # Main module
│   ├── toolbox/
│   │   ├── cli.rb                   # Thor CLI commands
│   │   ├── database.rb              # Database connection and setup
│   │   ├── generator.rb             # README generation logic
│   │   ├── models/
│   │   │   ├── category.rb          # Category ActiveRecord model
│   │   │   ├── project.rb           # Project ActiveRecord model
│   │   │   └── metadata.rb          # Metadata ActiveRecord model
│   │   └── parsers/
│   │       └── readme_parser.rb     # Parse existing README
├── templates/
│   └── readme.md.erb                # ERB template
├── db/
│   └── migrate/                     # ActiveRecord migrations
│       ├── 001_create_categories.rb
│       ├── 002_create_projects.rb
│       └── 003_create_metadata.rb
├── scripts/
│   ├── migrate_existing.rb          # Parse current README to database
│   └── backup.rb                    # Database backup utilities
└── spec/                            # RSpec tests
    ├── spec_helper.rb
    ├── models/
    ├── cli/
    └── generators/
```

## Dependencies

**Gemfile**:
```ruby
source 'https://rubygems.org'

gem 'thor', '~> 1.2'
gem 'activerecord', '~> 7.0'
gem 'sqlite3', '~> 1.4'
gem 'erb', '~> 4.0'
gem 'json', '~> 2.6'
gem 'nokogiri', '~> 1.13'  # For HTML/Markdown parsing
gem 'httparty', '~> 0.21'  # For URL validation

group :development, :test do
  gem 'rspec', '~> 3.12'
  gem 'factory_bot', '~> 6.2'
  gem 'faker', '~> 3.0'
end
```

## Key Ruby Components

### ActiveRecord Models

```ruby
# lib/toolbox/models/category.rb
class Category < ActiveRecord::Base
  has_many :projects, -> { order(:sort_order) }, dependent: :destroy
  
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  
  before_validation :generate_slug
  
  private
  
  def generate_slug
    self.slug = name.downcase.gsub(/[^a-z0-9]+/, '-') if name.present?
  end
end

# lib/toolbox/models/project.rb
class Project < ActiveRecord::Base
  belongs_to :category
  
  validates :name, presence: true
  validates :url, presence: true
  validates :description, presence: true
  
  serialize :features, JSON
  
  scope :by_category, ->(category_slug) { 
    joins(:category).where(categories: { slug: category_slug }) 
  }
end
```

### Thor CLI

```ruby
# lib/toolbox/cli.rb
class Toolbox::CLI < Thor
  desc "init", "Initialize database with schema"
  def init
    Toolbox::Database.setup
    say "Database initialized successfully!"
  end
  
  desc "category SUBCOMMAND", "Manage categories"
  subcommand "category", Toolbox::CLI::Category
  
  desc "project SUBCOMMAND", "Manage projects"
  subcommand "project", Toolbox::CLI::Project
  
  desc "generate", "Generate README.md from database"
  option :output, default: "README.md"
  def generate
    generator = Toolbox::Generator.new
    content = generator.generate
    File.write(options[:output], content)
    say "Generated #{options[:output]} successfully!"
  end
end
```

## Success Criteria

1. ✅ Database accurately represents all current README content
2. ✅ Generated README matches current formatting and structure
3. ✅ CLI provides intuitive project management
4. ✅ Easy to add new categories and projects
5. ✅ Version control friendly (readable diffs)
6. ✅ Fast generation (< 1 second for current dataset size)

## Future Enhancements

- **Web Interface**: Simple Sinatra web UI for non-technical contributors
- **API Integration**: Automatically fetch project metadata from GitHub API
- **Analytics**: Track project popularity, last updated dates
- **Validation**: Check for broken links, outdated information
- **Multiple Formats**: Generate different output formats (JSON, CSV, etc.)
- **Internationalization**: Support multiple languages using I18n gem