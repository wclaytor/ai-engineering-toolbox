# AI Engineering Toolbox CLI

A Ruby CLI tool for managing the AI Engineering Toolbox project database and generating README.md files.

## Development Setup

This project is configured to run in a Dev Container for GitHub Codespaces.

### Quick Start

1. Open this repository in GitHub Codespaces
2. The Dev Container will automatically set up Ruby, SQLite, and dependencies
3. Run `bundle install` to install gems
4. Initialize the database: `./toolbox init`
5. Check the CLI: `./toolbox version`

### Available Commands

```bash
# Show version
./toolbox version

# Initialize database
./toolbox init

# Show statistics
./toolbox stats

# Generate README (when data is available)
./toolbox generate
```

## Architecture

- **Language**: Ruby 3.2+
- **Database**: SQLite 3.x
- **CLI Framework**: Thor
- **ORM**: ActiveRecord
- **Templates**: ERB

## Project Structure

```
├── .devcontainer/          # Dev Container configuration
├── lib/toolbox/           # Main library code
├── templates/             # ERB templates
├── toolbox               # CLI executable
└── Gemfile               # Ruby dependencies
```

## Features

- Category and project management
- README.md generation from templates
- SQLite database for structured data
- Thor-based CLI interface
- ActiveRecord for database operations

This tool is designed to automate the maintenance of the AI Engineering Toolbox README.md file.