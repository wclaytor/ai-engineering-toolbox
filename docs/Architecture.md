# AI Engineering Toolbox Architecture

## System Overview

The AI Engineering Toolbox automation system follows a clear separation of concerns with a database-driven architecture for content management and templated generation.

```mermaid
graph TB
    subgraph "Data Layer"
        DB[(SQLite Database)]
        AR[ActiveRecord Models]
    end
    
    subgraph "Business Logic"
        CLI[Thor CLI]
        GEN[Generator]
        PARSE[Parser]
        VAL[Validator]
    end
    
    subgraph "Presentation Layer"
        TEMP[ERB Templates]
        README[Generated README.md]
    end
    
    subgraph "External Systems"
        GH[GitHub Repository]
        CI[GitHub Actions]
    end
    
    DB --> AR
    AR --> CLI
    AR --> GEN
    AR --> VAL
    GEN --> TEMP
    TEMP --> README
    PARSE --> AR
    CLI --> PARSE
    CLI --> GEN
    README --> GH
    GH --> CI
    CI --> CLI
```

## Database Schema

The system uses SQLite with ActiveRecord for data persistence and object-relational mapping.

```mermaid
erDiagram
    categories {
        integer id PK
        text name
        text slug UK
        text description
        integer sort_order
        timestamp created_at
        timestamp updated_at
    }
    
    projects {
        integer id PK
        integer category_id FK
        text name
        text url
        text description
        text features
        integer sort_order
        timestamp created_at
        timestamp updated_at
    }
    
    metadata {
        text key PK
        text value
    }
    
    categories ||--o{ projects : "has_many"
```

### Table Relationships

- **categories**: Master list of project categories with ordering
- **projects**: Individual tools/projects belonging to categories
- **metadata**: Key-value store for README header content and configuration

### Key Constraints

- Category slugs must be unique for URL generation
- Projects are ordered within categories via `sort_order`
- Categories are ordered globally via `sort_order`
- Features are stored as JSON arrays for flexible bullet points

## Component Architecture

### CLI Layer

```mermaid
graph LR
    subgraph "Thor CLI Framework"
        MAIN[toolbox]
        CAT[category commands]
        PROJ[project commands]
        GEN[generate command]
        UTIL[utility commands]
    end
    
    MAIN --> CAT
    MAIN --> PROJ
    MAIN --> GEN
    MAIN --> UTIL
    
    CAT --> AR1[ActiveRecord Models]
    PROJ --> AR2[ActiveRecord Models]
    GEN --> GENERATOR[Generator Engine]
    UTIL --> VAL[Validator]
```

#### Command Structure

```
toolbox
├── init                    # Database initialization
├── category
│   ├── add                 # Create new category
│   ├── list                # List all categories
│   ├── update              # Modify category
│   └── delete              # Remove category
├── project
│   ├── add                 # Create new project
│   ├── list                # List projects (optionally filtered)
│   ├── update              # Modify project
│   └── delete              # Remove project
├── import                  # Import from JSON/CSV
├── export                  # Export to JSON/CSV
├── generate                # Generate README.md
├── validate                # Check data integrity
├── search                  # Search projects
└── stats                   # Database statistics
```

### Generation Pipeline

```mermaid
sequenceDiagram
    participant CLI
    participant Generator
    participant Database
    participant Template
    participant FileSystem
    
    CLI->>Generator: generate()
    Generator->>Database: load categories with projects
    Database-->>Generator: ordered data
    Generator->>Database: load metadata
    Database-->>Generator: header content
    Generator->>Template: render(data)
    Template-->>Generator: rendered content
    Generator->>FileSystem: write README.md
    Generator-->>CLI: success/failure
```

### Data Flow

```mermaid
flowchart TD
    START([Start Generation]) --> LOAD[Load Categories]
    LOAD --> ORDER[Order by sort_order]
    ORDER --> PROJECTS[Load Associated Projects]
    PROJECTS --> META[Load Metadata]
    META --> RENDER[Render ERB Template]
    RENDER --> VALIDATE[Validate Output]
    VALIDATE --> WRITE[Write to File]
    WRITE --> END([Complete])
    
    VALIDATE -->|Invalid| ERROR[Handle Error]
    ERROR --> END
```

## Template System

The system uses ERB (Embedded Ruby) for template rendering with a single master template.

```mermaid
graph TB
    subgraph "Template Processing"
        DATA[(Database Data)]
        ERB[ERB Template Engine]
        TEMPLATE[readme.md.erb]
        OUTPUT[Generated README.md]
    end
    
    DATA --> ERB
    TEMPLATE --> ERB
    ERB --> OUTPUT
    
    subgraph "Template Structure"
        HEADER[Header & Description]
        TOC[Table of Contents]
        GETTING[Getting Started Section]
        CATEGORIES[Category Sections]
        PROJECTS[Project Entries]
    end
    
    ERB --> HEADER
    ERB --> TOC
    ERB --> GETTING
    ERB --> CATEGORIES
    ERB --> PROJECTS
```

### Template Data Structure

```ruby
# Data structure passed to ERB template
{
  metadata: {
    'title' => 'AI Engineering Toolbox',
    'description' => 'A list of open-source tools...',
    'getting_started' => 'Content for getting started section'
  },
  categories: [
    {
      id: 1,
      name: 'Application Development Frameworks',
      slug: 'application-development-frameworks',
      description: 'Optional category description',
      projects: [
        {
          name: 'LangChain',
          url: 'https://github.com/langchain-ai/langchain',
          description: 'Framework for building LLM-powered applications',
          features: ['Component chaining', 'Third-party integrations']
        }
      ]
    }
  ]
}
```

## Migration & Parsing

The system includes a migration path from the current manual README to the database-driven approach.

```mermaid
flowchart LR
    subgraph "Migration Process"
        CURRENT[Current README.md]
        PARSER[README Parser]
        EXTRACTOR[Content Extractor]
        VALIDATOR[Data Validator]
        DATABASE[(SQLite Database)]
    end
    
    CURRENT --> PARSER
    PARSER --> EXTRACTOR
    EXTRACTOR --> VALIDATOR
    VALIDATOR --> DATABASE
    
    subgraph "Parsing Steps"
        HEADERS[Extract Headers]
        CATEGORIES[Identify Categories]
        PROJECTS[Parse Project Entries]
        LINKS[Extract URLs]
        FEATURES[Parse Bullet Points]
    end
    
    PARSER --> HEADERS
    PARSER --> CATEGORIES
    PARSER --> PROJECTS
    PARSER --> LINKS
    PARSER --> FEATURES
```

### Parser Logic

```mermaid
graph TD
    START([Start Parsing]) --> READ[Read README.md]
    READ --> SPLIT[Split by ## Headers]
    SPLIT --> FILTER[Filter Categories]
    FILTER --> LOOP{For Each Category}
    
    LOOP --> EXTRACT[Extract Projects]
    EXTRACT --> PROJECT_LOOP{For Each Project}
    
    PROJECT_LOOP --> GET_NAME[Get Project Name]
    GET_NAME --> GET_URL[Get URL]
    GET_URL --> GET_DESC[Get Description]
    GET_DESC --> GET_FEATURES[Get Features List]
    GET_FEATURES --> SAVE_PROJECT[Save to Database]
    
    SAVE_PROJECT --> PROJECT_LOOP
    PROJECT_LOOP -->|No More Projects| LOOP
    LOOP -->|No More Categories| VALIDATE[Validate Migration]
    VALIDATE --> END([Complete])
```

## File Organization

```
/workspaces/ai-engineering-toolbox/
├── lib/toolbox/
│   ├── cli/                     # CLI command classes
│   │   ├── base.rb              # Shared CLI functionality
│   │   ├── category.rb          # Category management commands
│   │   ├── project.rb           # Project management commands
│   │   └── generator.rb         # Generation commands
│   ├── models/                  # ActiveRecord models
│   │   ├── base.rb              # Base model class
│   │   ├── category.rb          # Category model
│   │   ├── project.rb           # Project model
│   │   └── metadata.rb          # Metadata model
│   ├── parsers/                 # Content parsing
│   │   └── readme_parser.rb     # README.md parser
│   ├── generators/              # Content generation
│   │   ├── base.rb              # Base generator
│   │   └── readme_generator.rb  # README generator
│   ├── validators/              # Data validation
│   │   ├── url_validator.rb     # URL health checks
│   │   └── data_validator.rb    # Data integrity
│   ├── database.rb              # Database setup and connection
│   └── version.rb               # Version information
├── db/
│   ├── migrate/                 # ActiveRecord migrations
│   └── seeds.rb                 # Seed data
├── templates/
│   └── readme.md.erb            # Master template
├── scripts/
│   ├── migrate_existing.rb      # Migration script
│   └── backup.rb                # Backup utilities
└── spec/                        # RSpec test suite
    ├── models/
    ├── cli/
    ├── generators/
    └── integration/
```

## Security & Data Integrity

### Data Validation

```mermaid
graph TB
    subgraph "Validation Layers"
        MODEL[ActiveRecord Validations]
        CLI[CLI Input Validation]
        URL[URL Health Checks]
        INTEGRITY[Database Integrity]
    end
    
    subgraph "Validation Rules"
        REQUIRED[Required Fields]
        UNIQUE[Uniqueness Constraints]
        FORMAT[Format Validation]
        REFERENCE[Foreign Key Integrity]
    end
    
    MODEL --> REQUIRED
    MODEL --> UNIQUE
    CLI --> FORMAT
    URL --> FORMAT
    INTEGRITY --> REFERENCE
```

### Backup Strategy

```mermaid
sequenceDiagram
    participant User
    participant CLI
    participant Database
    participant Backup
    participant Git
    
    User->>CLI: Major operation
    CLI->>Backup: Create backup
    Backup->>Database: Export data
    Database-->>Backup: Data dump
    Backup->>Git: Commit backup
    CLI->>Database: Perform operation
    Database-->>CLI: Result
    CLI-->>User: Success/Failure
```

## Performance Considerations

### Query Optimization

- Categories and projects loaded with single queries using `includes()`
- Database indexes on frequently queried fields (`slug`, `sort_order`)
- Minimal data loading for generation (only required fields)

### Generation Performance

```mermaid
graph LR
    subgraph "Performance Optimizations"
        LAZY[Lazy Loading]
        CACHE[Template Caching]
        BATCH[Batch Operations]
        INDEX[Database Indexes]
    end
    
    subgraph "Performance Targets"
        GEN[Generation < 1s]
        CLI[CLI Commands < 100ms]
        MEMORY[Low Memory Usage]
        SCALE[Handles 1000+ Projects]
    end
    
    LAZY --> GEN
    CACHE --> GEN
    BATCH --> CLI
    INDEX --> CLI
```

## Error Handling & Monitoring

```mermaid
graph TB
    subgraph "Error Types"
        DB_ERROR[Database Errors]
        VALIDATION[Validation Errors]
        IO_ERROR[File I/O Errors]
        TEMPLATE[Template Errors]
    end
    
    subgraph "Error Handling"
        LOGGING[Structured Logging]
        RECOVERY[Graceful Recovery]
        MESSAGES[User-Friendly Messages]
        ROLLBACK[Transaction Rollback]
    end
    
    DB_ERROR --> LOGGING
    DB_ERROR --> ROLLBACK
    VALIDATION --> MESSAGES
    IO_ERROR --> RECOVERY
    TEMPLATE --> LOGGING
```

This architecture provides a robust, maintainable foundation for automating the AI Engineering Toolbox README generation while ensuring data integrity, performance, and ease of use.