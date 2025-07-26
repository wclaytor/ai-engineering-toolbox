# AI Engineering Toolbox - Claude Context

## Project Overview

This project automates the generation of the AI Engineering Toolbox README.md from a SQLite database using Ruby, ActiveRecord, and ERB templates. The goal is to replace manual README maintenance with a structured, database-driven approach.

## Key Commands

```bash
# Project setup
bundle install                        # Install Ruby dependencies
./toolbox init                       # Initialize database with schema

# Category management
./toolbox category add "Name" --description="..." --order=10
./toolbox category list
./toolbox category update <id> --name="..." --order=5
./toolbox category delete <id>

# Project management
./toolbox project add --category="frameworks" --name="LangChain" \
  --url="https://github.com/langchain-ai/langchain" \
  --description="Framework description" \
  --features='["Feature 1", "Feature 2"]'
./toolbox project list [--category=<slug>]
./toolbox project update <id> --name="..." --description="..."
./toolbox project delete <id>

# Generation and validation
./toolbox generate                   # Generate README.md
./toolbox generate --output=custom.md
./toolbox validate                   # Check data integrity
./toolbox search "term"              # Search projects
./toolbox stats                      # Database statistics

# Import/Export
./toolbox import data.json
./toolbox export --format=json
./toolbox export --format=csv

# Testing
bundle exec rspec                    # Run test suite
bundle exec rspec spec/models/       # Run model tests only
```

## Core Files and Structure

```
/workspaces/ai-engineering-toolbox/
├── lib/toolbox/
│   ├── cli.rb                      # Main Thor CLI interface
│   ├── database.rb                 # Database connection and setup
│   ├── generator.rb                # README generation engine
│   ├── models/                     # ActiveRecord models
│   │   ├── category.rb             # Category model with slug generation
│   │   ├── project.rb              # Project model with JSON features
│   │   └── metadata.rb             # Key-value metadata storage
│   ├── parsers/
│   │   └── readme_parser.rb        # Parse existing README content
│   └── validators/
│       └── data_validator.rb       # Data integrity validation
├── db/
│   ├── migrate/                    # ActiveRecord migrations
│   └── toolbox.db                  # SQLite database (after init)
├── templates/
│   └── readme.md.erb               # ERB template for README generation
├── docs/                           # Project documentation
│   ├── Requirements.md             # Complete functional requirements
│   ├── Specification.md            # Technical architecture and APIs
│   ├── Architecture.md             # System design and data flow
│   ├── Plan.md                     # Implementation timeline
│   └── Implementation.md           # Step-by-step implementation guide
├── Gemfile                         # Ruby dependencies
├── toolbox                         # Executable CLI script
└── README.md                       # Generated output (current manual version)
```

## Database Schema

```sql
-- Categories table
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,                 -- Display name
  slug TEXT NOT NULL UNIQUE,          -- URL-friendly identifier
  description TEXT,                   -- Optional description
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Projects table  
CREATE TABLE projects (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category_id INTEGER NOT NULL,
  name TEXT NOT NULL,                 -- Project name
  url TEXT NOT NULL,                  -- GitHub/project URL
  description TEXT NOT NULL,          -- Project description
  features TEXT,                      -- JSON array of features/bullet points
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- Metadata table
CREATE TABLE metadata (
  key TEXT PRIMARY KEY,               -- Configuration key
  value TEXT NOT NULL                 -- Configuration value
);
```

## Code Style Guidelines

- **Ruby Style**: Follow standard Ruby conventions with 2-space indentation
- **ActiveRecord**: Use Rails-style model validations and associations
- **CLI Design**: Thor-based commands with clear help text and error messages
- **Error Handling**: Provide user-friendly error messages with actionable guidance
- **Testing**: Use RSpec with factory_bot for test data generation
- **Database**: Use ActiveRecord migrations for schema changes

## Key Implementation Rules

### IMPORTANT: Data Integrity
- **YOU MUST** preserve all existing README content during migration
- **YOU MUST** validate that generated README matches manual version byte-for-byte
- **YOU MUST** implement rollback mechanisms for failed operations
- Always create backups before major database operations

### Performance Requirements
- README generation **MUST** complete in < 1 second
- CLI commands **MUST** respond in < 100ms for typical operations
- Database operations **MUST** complete in < 50ms for CRUD operations
- System **MUST** handle 1000+ projects efficiently

### Validation Requirements
- **ALWAYS** validate URLs for proper format and accessibility
- **ALWAYS** check foreign key constraints before deletion
- **ALWAYS** sanitize user inputs to prevent SQL injection
- **ALWAYS** validate JSON format for project features arrays

## Template Structure

The ERB template (`templates/readme.md.erb`) generates:
1. Header with title and description from metadata
2. Table of contents with category links
3. Getting Started section from metadata
4. Category sections with projects in sort order
5. Project entries with name, URL, description, and features

## Testing Strategy

```bash
# Run full test suite
bundle exec rspec

# Test specific components
bundle exec rspec spec/models/category_spec.rb
bundle exec rspec spec/cli/project_spec.rb
bundle exec rspec spec/generators/readme_generator_spec.rb

# Performance tests
bundle exec rspec spec/performance/ --tag performance

# Integration tests
bundle exec rspec spec/integration/ --tag integration
```

## Common Workflows

### Adding a New Project
1. Ensure category exists: `./toolbox category list`
2. Add project: `./toolbox project add --category="slug" --name="..." --url="..." --description="..." --features='[...]'`
3. Validate: `./toolbox validate`
4. Generate: `./toolbox generate`
5. Review output and commit changes

### Migration from Manual README
1. Backup current README: `cp README.md README.backup.md`
2. Initialize database: `./toolbox init`
3. Run migration script: `ruby scripts/migrate_existing.rb`
4. Validate migration: `./toolbox validate`
5. Generate and compare: `./toolbox generate --output=README.generated.md && diff README.md README.generated.md`

### Troubleshooting
- **Database locked**: Check for running processes, restart if needed
- **Generation mismatch**: Compare templates, check data ordering
- **URL validation fails**: Verify network connectivity, check URL format
- **Migration issues**: Check parser logic, validate source README format

## Project Status

**Current Phase**: Foundation & Infrastructure (Phase 1)
**Next Milestone**: Data Migration & Basic CLI (Phase 2)

**Success Criteria**:
- [ ] All existing README content migrated (100%)
- [ ] Generated README matches manual version exactly  
- [ ] Test coverage > 95%
- [ ] All performance targets met
- [ ] CLI provides intuitive project management

## Development Notes

- Use `ActiveRecord::Base.transaction` for multi-step operations requiring rollback
- Implement slug generation automatically from category names
- Store project features as JSON arrays for flexible bullet point management
- Use ERB's trim mode (`-`) to control whitespace in generated output
- Implement comprehensive logging for debugging generation issues

## Related Documentation

All detailed specifications are in the `docs/` directory:
- `Requirements.md` - Complete functional and non-functional requirements
- `Specification.md` - Technical APIs and implementation details  
- `Architecture.md` - System design and component relationships
- `Plan.md` - Implementation phases and timeline
- `Implementation.md` - Step-by-step development guide