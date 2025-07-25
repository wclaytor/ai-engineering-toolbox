# AI Engineering Toolbox Automation - Technical Specification

## Document Information

- **Version**: 1.0
- **Date**: July 25, 2025
- **Status**: Draft
- **Authors**: AI Engineering Toolbox Team

## Executive Summary

This specification defines the technical requirements for automating the AI Engineering Toolbox README.md generation through a database-driven system. The project replaces manual README maintenance with a structured SQLite database and programmatic generation using Ruby, ActiveRecord, and ERB templates.

## Functional Requirements

### FR-001: Database Management
- **Requirement**: The system SHALL provide a SQLite database to store project and category information
- **Priority**: High
- **Acceptance Criteria**:
  - Database schema includes categories, projects, and metadata tables
  - Support for foreign key relationships and constraints
  - Automatic timestamp tracking for created_at/updated_at fields

### FR-002: CLI Interface
- **Requirement**: The system SHALL provide a Thor-based CLI for all operations
- **Priority**: High
- **Acceptance Criteria**:
  - Commands respond within 100ms for typical operations
  - Intuitive command structure with help documentation
  - Support for batch operations and data validation

### FR-003: Category Management
- **Requirement**: The system SHALL support CRUD operations for categories
- **Priority**: High
- **Acceptance Criteria**:
  ```bash
  toolbox category add "Category Name" --description="..." --order=10
  toolbox category list
  toolbox category update <id> --name="..." --order=5
  toolbox category delete <id>
  ```

### FR-004: Project Management
- **Requirement**: The system SHALL support CRUD operations for projects
- **Priority**: High
- **Acceptance Criteria**:
  ```bash
  toolbox project add --category="frameworks" --name="LangChain" \
    --url="https://github.com/langchain-ai/langchain" \
    --description="Framework for building LLM-powered applications" \
    --features='["Component chaining", "Third-party integrations"]'
  toolbox project list [--category=<slug>]
  toolbox project update <id> --name="..." --description="..."
  toolbox project delete <id>
  ```

### FR-005: README Generation
- **Requirement**: The system SHALL generate README.md identical to manual version
- **Priority**: Critical
- **Acceptance Criteria**:
  - Generated output matches current README byte-for-byte
  - Generation completes in under 1 second
  - Support for custom output file paths

### FR-006: Data Import/Export
- **Requirement**: The system SHALL support importing and exporting data
- **Priority**: Medium
- **Acceptance Criteria**:
  ```bash
  toolbox import data.json
  toolbox export --format=json
  toolbox export --format=csv
  ```

### FR-007: Search and Filtering
- **Requirement**: The system SHALL provide search capabilities
- **Priority**: Medium
- **Acceptance Criteria**:
  ```bash
  toolbox search "langchain"
  toolbox project list --category="frameworks"
  toolbox stats
  ```

### FR-008: Data Migration
- **Requirement**: The system SHALL migrate existing README content to database
- **Priority**: High
- **Acceptance Criteria**:
  - Parse current README.md structure
  - Extract all categories, projects, and metadata
  - Preserve project descriptions and feature lists
  - Validate migration completeness

### FR-009: Data Validation
- **Requirement**: The system SHALL validate data integrity
- **Priority**: High
- **Acceptance Criteria**:
  ```bash
  toolbox validate
  ```
  - Check for broken URLs
  - Validate required fields
  - Ensure foreign key integrity
  - Report validation errors with actionable messages

## Non-Functional Requirements

### NFR-001: Performance
- **Requirement**: System performance SHALL meet specified benchmarks
- **Criteria**:
  - README generation: < 1 second
  - CLI commands: < 100ms response time
  - Database operations: < 50ms for CRUD operations
  - Support for 1000+ projects without performance degradation

### NFR-002: Reliability
- **Requirement**: System SHALL be highly reliable
- **Criteria**:
  - Zero data loss during operations
  - Graceful error handling with rollback capabilities
  - Database integrity checks and validation
  - Comprehensive test coverage (>95%)

### NFR-003: Maintainability
- **Requirement**: System SHALL be maintainable and extensible
- **Criteria**:
  - Clean separation of concerns
  - Comprehensive documentation
  - Modular architecture
  - Consistent coding standards

### NFR-004: Usability
- **Requirement**: System SHALL be user-friendly
- **Criteria**:
  - Intuitive CLI commands with clear help text
  - Meaningful error messages
  - Simple project addition workflow
  - Support for non-technical users

### NFR-005: Compatibility
- **Requirement**: System SHALL be compatible with target environments
- **Criteria**:
  - Linux, macOS, Windows support
  - Ruby 3.0+ compatibility
  - SQLite 3.x compatibility
  - Git integration for version control

## Technical Specifications

### Database Schema

```sql
-- Categories table
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Projects table
CREATE TABLE projects (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  description TEXT NOT NULL,
  features TEXT, -- JSON array
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- Metadata table
CREATE TABLE metadata (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

-- Indexes for performance
CREATE INDEX idx_categories_sort_order ON categories(sort_order);
CREATE INDEX idx_projects_category_id ON projects(category_id);
CREATE INDEX idx_projects_sort_order ON projects(sort_order);
CREATE INDEX idx_categories_slug ON categories(slug);
```

### ActiveRecord Models

```ruby
# Category model
class Category < ActiveRecord::Base
  has_many :projects, -> { order(:sort_order) }, dependent: :destroy
  
  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :slug, presence: true, uniqueness: true, 
            format: { with: /\A[a-z0-9-]+\z/ }
  validates :sort_order, presence: true, numericality: { integer: true }
  
  before_validation :generate_slug, if: :name_changed?
  before_save :update_timestamp
  
  scope :ordered, -> { order(:sort_order, :name) }
  
  private
  
  def generate_slug
    return unless name.present?
    self.slug = name.downcase
                   .gsub(/[^a-z0-9\s-]/, '')
                   .gsub(/\s+/, '-')
                   .gsub(/-+/, '-')
                   .strip('-')
  end
  
  def update_timestamp
    self.updated_at = Time.current
  end
end

# Project model
class Project < ActiveRecord::Base
  belongs_to :category
  
  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :description, presence: true, length: { minimum: 10 }
  validates :sort_order, presence: true, numericality: { integer: true }
  
  serialize :features, JSON
  
  before_save :update_timestamp
  before_validation :validate_features
  
  scope :by_category, ->(category_slug) { 
    joins(:category).where(categories: { slug: category_slug }) 
  }
  scope :ordered, -> { order(:sort_order, :name) }
  
  private
  
  def update_timestamp
    self.updated_at = Time.current
  end
  
  def validate_features
    return unless features.present?
    unless features.is_a?(Array) && features.all? { |f| f.is_a?(String) }
      errors.add(:features, 'must be an array of strings')
    end
  end
end

# Metadata model
class Metadata < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true
  
  def self.get(key)
    find_by(key: key)&.value
  end
  
  def self.set(key, value)
    record = find_or_initialize_by(key: key)
    record.value = value
    record.save!
  end
end
```

### CLI Command Structure

```ruby
# Main CLI class
class Toolbox::CLI < Thor
  desc "init", "Initialize database with schema"
  def init
    Toolbox::Database.setup
    say "Database initialized successfully!", :green
  rescue => e
    say "Error initializing database: #{e.message}", :red
    exit 1
  end
  
  desc "category SUBCOMMAND", "Manage categories"
  subcommand "category", Toolbox::CLI::Category
  
  desc "project SUBCOMMAND", "Manage projects"  
  subcommand "project", Toolbox::CLI::Project
  
  desc "generate", "Generate README.md from database"
  option :output, default: "README.md", desc: "Output file path"
  option :validate, type: :boolean, default: true, desc: "Validate before generation"
  def generate
    if options[:validate]
      validator = Toolbox::Validator.new
      unless validator.valid?
        say "Validation failed:", :red
        validator.errors.each { |error| say "  - #{error}", :red }
        exit 1
      end
    end
    
    generator = Toolbox::Generator.new
    content = generator.generate
    File.write(options[:output], content)
    say "Generated #{options[:output]} successfully!", :green
  rescue => e
    say "Error generating README: #{e.message}", :red
    exit 1
  end
  
  desc "validate", "Validate database integrity"
  def validate
    validator = Toolbox::Validator.new
    if validator.valid?
      say "Database validation passed!", :green
    else
      say "Validation failed:", :red
      validator.errors.each { |error| say "  - #{error}", :red }
      exit 1
    end
  end
  
  desc "search TERM", "Search projects and descriptions"
  def search(term)
    results = Toolbox::Search.new(term).execute
    if results.empty?
      say "No results found for '#{term}'", :yellow
    else
      say "Found #{results.count} results:", :green
      results.each do |project|
        say "  #{project.name} (#{project.category.name})", :cyan
        say "    #{project.url}", :blue
      end
    end
  end
  
  desc "stats", "Show database statistics"
  def stats
    stats = Toolbox::Statistics.new.generate
    say "Database Statistics:", :green
    say "  Categories: #{stats[:categories]}", :cyan
    say "  Projects: #{stats[:projects]}", :cyan
    say "  Last updated: #{stats[:last_updated]}", :cyan
  end
end
```

### Template Specification

```erb
# AI Engineering Toolbox
<%= Metadata.get('description') || 'A list of open-source tools and resources for AI Engineering' %>

## Table of Contents

<% categories.each do |category| -%>
- [<%= category.name %>](#<%= category.slug %>)
<% end -%>

-----

<%= Metadata.get('getting_started') %>

<% categories.each do |category| -%>
## <%= category.name %>

<% if category.description.present? -%>
<%= category.description %>

<% end -%>
<% category.projects.each do |project| -%>
### <%= project.name %>
<%= project.url %>

#### Description
<%= project.description %>

<% if project.features && project.features.any? -%>
<% project.features.each do |feature| -%>
- <%= feature %>
<% end -%>

<% end -%>
<% end -%>
<% end -%>

-----

to be continued...
```

## API Specifications

### Generator API

```ruby
class Toolbox::Generator
  def initialize(template_path: nil)
    @template_path = template_path || default_template_path
  end
  
  def generate
    validate_template
    data = load_data
    render_template(data)
  end
  
  private
  
  def load_data
    {
      categories: Category.includes(:projects).ordered,
      metadata: load_metadata
    }
  end
  
  def render_template(data)
    template = ERB.new(File.read(@template_path), trim_mode: '-')
    template.result(binding)
  end
  
  def validate_template
    raise "Template not found: #{@template_path}" unless File.exist?(@template_path)
  end
  
  def default_template_path
    File.join(Toolbox.root, 'templates', 'readme.md.erb')
  end
end
```

### Parser API

```ruby
class Toolbox::Parser::ReadmeParser
  def initialize(readme_path)
    @readme_path = readme_path
    @content = File.read(readme_path)
  end
  
  def parse
    {
      metadata: extract_metadata,
      categories: extract_categories
    }
  end
  
  private
  
  def extract_metadata
    {
      'title' => extract_title,
      'description' => extract_description,
      'getting_started' => extract_getting_started
    }
  end
  
  def extract_categories
    sections = split_into_sections
    sections.map { |section| parse_category(section) }
  end
  
  def parse_category(section)
    {
      name: extract_category_name(section),
      description: extract_category_description(section),
      projects: extract_projects(section)
    }
  end
end
```

## Error Handling Specifications

### Error Categories

1. **Database Errors**
   - Connection failures
   - Schema migration errors
   - Data integrity violations
   - Transaction rollback scenarios

2. **Validation Errors**
   - Invalid URLs
   - Missing required fields
   - Data format violations
   - Foreign key constraint violations

3. **File System Errors**
   - Template file not found
   - Permission denied
   - Disk space insufficient
   - Invalid file paths

4. **Generation Errors**
   - Template rendering failures
   - Data serialization errors
   - Output validation failures

### Error Response Format

```ruby
class Toolbox::Error < StandardError
  attr_reader :code, :details
  
  def initialize(message, code: nil, details: {})
    super(message)
    @code = code
    @details = details
  end
end

# Usage examples
raise Toolbox::ValidationError.new(
  "URL validation failed", 
  code: "INVALID_URL",
  details: { url: "invalid-url", project_id: 123 }
)
```

## Security Specifications

### Input Validation
- Sanitize all user inputs
- Validate URLs before storage
- Escape special characters in generated content
- Limit input length for all text fields

### Data Protection
- Database file permissions (600)
- Backup encryption for sensitive data
- Secure handling of temporary files
- Input sanitization for SQL injection prevention

### URL Validation
```ruby
class Toolbox::URLValidator
  ALLOWED_SCHEMES = %w[http https].freeze
  
  def self.valid?(url)
    uri = URI.parse(url)
    ALLOWED_SCHEMES.include?(uri.scheme) && 
    uri.host.present? &&
    reachable?(uri)
  rescue URI::InvalidURIError
    false
  end
  
  private
  
  def self.reachable?(uri)
    response = HTTParty.head(uri.to_s, timeout: 5)
    response.success?
  rescue
    false
  end
end
```

## Testing Specifications

### Unit Tests
- Model validations and methods (100% coverage)
- CLI command parsing and execution
- Generator template rendering
- Parser content extraction
- Validator logic and error handling

### Integration Tests
- End-to-end workflow testing
- Database migration and rollback
- Full README generation pipeline
- Error recovery scenarios

### Performance Tests
```ruby
RSpec.describe "Performance", type: :performance do
  it "generates README in under 1 second" do
    expect { generator.generate }.to perform_under(1.second)
  end
  
  it "handles 1000 projects efficiently" do
    create_list(:project, 1000)
    expect { generator.generate }.to perform_under(2.seconds)
  end
end
```

## Deployment Specifications

### Environment Requirements
- Ruby 3.0 or higher
- SQLite 3.x
- Git for version control
- 100MB disk space minimum

### Installation Process
```bash
# Clone repository
git clone https://github.com/user/ai-engineering-toolbox.git
cd ai-engineering-toolbox

# Install dependencies
bundle install

# Initialize database
./toolbox init

# Migrate existing data
./toolbox import README.md

# Generate README
./toolbox generate
```

### CI/CD Integration
```yaml
# .github/workflows/readme-update.yml
name: Update README
on:
  push:
    paths: ['toolbox.db']
    
jobs:
  update-readme:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
      - run: bundle install
      - run: ./toolbox validate
      - run: ./toolbox generate
      - run: git add README.md && git commit -m "Auto-update README" && git push
```

## Success Criteria

### Functional Success
- [ ] All current README content migrated without loss
- [ ] Generated README identical to manual version
- [ ] CLI provides intuitive project management
- [ ] Search and filtering work correctly
- [ ] Import/export functionality complete

### Performance Success
- [ ] README generation < 1 second
- [ ] CLI commands respond < 100ms
- [ ] Database handles 1000+ projects
- [ ] Memory usage remains reasonable

### Quality Success
- [ ] Test coverage > 95%
- [ ] Zero critical bugs in production
- [ ] Comprehensive documentation
- [ ] User-friendly error messages
- [ ] Successful CI/CD integration

This specification provides a comprehensive technical foundation for implementing the AI Engineering Toolbox automation system, ensuring all requirements are clearly defined and measurable.