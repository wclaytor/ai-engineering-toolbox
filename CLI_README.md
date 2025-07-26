# AI Engineering Toolbox CLI

A Ruby CLI tool for managing the AI Engineering Toolbox project database and generating README.md files.

## Development Setup

This project is configured to run in a Dev Container for GitHub Codespaces.

### Quick Start with GitHub Codespaces

1. **Open in Codespaces**: Click the "Code" button on GitHub and select "Create codespace on main"
2. **Wait for Setup**: The Dev Container will automatically:
   - Set up Ruby 3.2+ environment
   - Install SQLite3 and development tools
   - Run `bundle install` to install all gems
   - Configure the project for development
3. **Initialize Database**: Run `bundle exec ./toolbox init`
4. **Load Demo Data**: Run `bundle exec ./toolbox demo`
5. **Check Status**: Run `bundle exec ./toolbox stats`

### Available Commands

```bash
# Show version and help
bundle exec ./toolbox version
bundle exec ./toolbox help

# Database management
bundle exec ./toolbox init        # Initialize database
bundle exec ./toolbox demo        # Load sample data for testing

# Data and statistics
bundle exec ./toolbox stats       # Show database statistics

# Content generation
bundle exec ./toolbox generate                    # Generate README.md
bundle exec ./toolbox generate --output=demo.md   # Generate to custom file
```

### Example Workflow

```bash
# 1. Initialize the system
bundle exec ./toolbox init

# 2. Load some demo data
bundle exec ./toolbox demo

# 3. Check what we have
bundle exec ./toolbox stats

# 4. Generate a README
bundle exec ./toolbox generate --output=demo.md

# 5. View the generated file
cat demo.md
```

## Architecture

- **Language**: Ruby 3.2+
- **Database**: SQLite 3.x
- **CLI Framework**: Thor
- **ORM**: ActiveRecord
- **Templates**: ERB

## Project Structure

```
├── .devcontainer/          # Dev Container configuration for Codespaces
│   └── devcontainer.json   # Container setup with Ruby, SQLite, tools
├── lib/toolbox/           # Main library code
│   ├── cli.rb             # Thor-based CLI commands
│   ├── database.rb        # Database setup and migrations
│   ├── generator.rb       # README generation engine
│   └── models/            # ActiveRecord models
│       ├── category.rb    # Project categories
│       ├── project.rb     # Individual projects
│       └── metadata.rb    # System metadata
├── templates/             # ERB templates for generation
│   └── readme.md.erb     # Main README template
├── scripts/              # Utility scripts
├── toolbox              # CLI executable
└── Gemfile              # Ruby dependencies
```

## Features

### ✅ Implemented
- **Dev Container**: Full GitHub Codespaces support with automatic setup
- **Database Management**: SQLite with ActiveRecord ORM
- **CLI Interface**: Thor-based commands with help system
- **Data Models**: Categories, Projects, and Metadata management
- **Template System**: ERB-based README generation
- **Sample Data**: Demo data loading for testing

### 🚧 Future Enhancements
- Category and project CRUD operations via CLI
- Import/export functionality (JSON, CSV)
- Search and filtering capabilities
- URL validation and reachability testing
- Migration from existing README.md
- GitHub Actions integration

## Development

### Local Development

If you prefer to develop locally instead of using Codespaces:

```bash
# Install Ruby 3.2+
# Install SQLite3
git clone <repository>
cd ai-engineering-toolbox
bundle install
bundle exec ./toolbox init
```

### Testing

```bash
# Initialize with demo data
bundle exec ./toolbox init
bundle exec ./toolbox demo

# Test generation
bundle exec ./toolbox generate --output=test.md

# Check statistics
bundle exec ./toolbox stats
```

## Database Schema

- **categories**: name, slug, description, sort_order
- **projects**: category_id, name, url, description, features (JSON), sort_order
- **metadata**: key-value pairs for system configuration

## Usage Examples

### Basic Setup
```bash
bundle exec ./toolbox init    # Create database
bundle exec ./toolbox demo    # Load sample data
bundle exec ./toolbox stats   # View statistics
```

### Content Generation
```bash
bundle exec ./toolbox generate                  # Generate README.md
bundle exec ./toolbox generate --output=docs.md # Custom output file
```

This tool provides the foundation for automating the maintenance of the AI Engineering Toolbox README.md file through a structured, database-driven approach.