# Project Overview

## Background

The AI Engineering Toolbox is transitioning from manual README maintenance to an automated, database-driven approach. The project replaces manual editing of README.md with a structured SQLite database and programmatic generation using Ruby, ActiveRecord, and ERB templates.

## Current Structure

The workspace contains a well-organized collection of AI tools across multiple categories including:

- **Application Development Frameworks** (LangChain, Agno, Roast, etc.)
- **Development Tools & IDE Extensions** (Prompt Tower, Roo-Code, etc.) 
- **Desktop & GUI Applications** (Kiln, Claudia, etc.)
- **Model Context Protocol (MCP)** implementations
- **Scientific & Research Tools**
- **Experimental & Research Projects**

## Architecture & Implementation

The automation system follows a clear architecture as defined in Architecture.md:

- **Database Layer**: SQLite with ActiveRecord models for categories, projects, and metadata
- **Business Logic**: Thor-based CLI for data management and generation
- **Presentation Layer**: ERB templates for README generation
- **Integration**: GitHub Actions for automated workflows

### Key Components

1. **CLI Tool** (`toolbox` command) for:
   - Category and project management
   - Database initialization and migration
   - README generation
   - Import/export functionality
   - Search and validation

2. **Database Schema** with three main tables:
   - `categories` - Tool categories with ordering
   - `projects` - Individual tools/projects
   - `metadata` - README header content

3. **Template System** using ERB to generate consistent formatting

## Documentation Structure

The project includes comprehensive documentation:

- Requirements.md - Functional and non-functional requirements
- Specification.md - Technical architecture and APIs  
- Plan.md - Implementation timeline and phases
- Architecture.md - System design and component architecture
- Implementation.md - Step-by-step implementation guide

## Content Management

The project tracks starred repositories and new tools in organized directories like 2025.07.25 with both structured data files and generated HTML/Markdown outputs.

## Goals

The automation aims to:
- Eliminate manual README maintenance overhead
- Ensure consistent formatting and structure
- Enable easy contribution from non-technical users
- Support scalable growth to 1000+ projects
- Maintain version control and data integrity

This is a sophisticated project that combines database design, Ruby development, templating, and automation to create a maintainable system for curating AI engineering resources.