module Toolbox
  class CLI < Thor
    def self.exit_on_failure?
      true
    end
    
    desc "version", "Show version information"
    def version
      puts "AI Engineering Toolbox v#{Toolbox::VERSION}"
    end
    
    desc "init", "Initialize database with schema"
    def init
      Toolbox::Database.setup
      puts "✅ Database initialized successfully!"
      puts "📍 Database location: #{Toolbox.database_path}"
    end
    
    desc "generate", "Generate README.md from database"
    option :output, default: "README.md", desc: "Output file path"
    def generate
      Toolbox::Database.setup
      generator = Toolbox::Generator.new
      content = generator.generate
      
      File.write(options[:output], content)
      puts "✅ Generated #{options[:output]} successfully!"
    end
    
    desc "stats", "Show database statistics"
    def stats
      Toolbox::Database.setup
      
      category_count = Category.count
      project_count = Project.count
      
      puts "📊 AI Engineering Toolbox Statistics"
      puts "   Categories: #{category_count}"
      puts "   Projects: #{project_count}"
      
      if category_count > 0
        puts "\n📁 Categories:"
        Category.order(:sort_order).each do |category|
          puts "   #{category.name} (#{category.projects.count} projects)"
        end
      end
    end
    
    desc "demo", "Load sample data for demonstration"
    def demo
      Toolbox::Database.setup
      
      if Category.count > 0 || Project.count > 0
        puts "⚠️  Database already contains data. Use 'reset' first to clear it."
        return
      end
      
      sample_data = [
        {
          category: { name: "Application Development Frameworks", description: "Frameworks for building AI applications" },
          projects: [
            {
              name: "LangChain",
              url: "https://github.com/langchain-ai/langchain",
              description: "LangChain is a framework for building LLM-powered applications. It helps you chain together interoperable components and third-party integrations to simplify AI application development — all while future-proofing decisions as the underlying technology evolves.",
              features: ["Component chaining", "Third-party integrations", "Future-proof architecture"]
            },
            {
              name: "LangGraph",
              url: "https://github.com/langchain-ai/langgraph",
              description: "Trusted by companies shaping the future of agents – including Klarna, Replit, Elastic, and more – LangGraph is a low-level orchestration framework for building, managing, and deploying long-running, stateful agents.",
              features: ["Low-level orchestration", "Stateful agents", "Agent management"]
            }
          ]
        },
        {
          category: { name: "Local AI & Model Deployment", description: "Tools for running AI models locally" },
          projects: [
            {
              name: "Ollama",
              url: "https://github.com/ollama/ollama",
              description: "Get up and running with large language models.",
              features: ["Local model hosting", "Easy setup", "Multiple model support"]
            }
          ]
        }
      ]

      sample_data.each_with_index do |data, index|
        category = Category.create!(
          name: data[:category][:name],
          description: data[:category][:description],
          sort_order: index
        )
        
        data[:projects].each_with_index do |project_data, project_index|
          Project.create!(
            category: category,
            name: project_data[:name],
            url: project_data[:url],
            description: project_data[:description],
            features: project_data[:features],
            sort_order: project_index
          )
        end
      end

      # Add some metadata
      Metadata.set('title', 'AI Engineering Toolbox')
      Metadata.set('description', 'A list of open-source tools and resources for AI Engineering')

      puts "✅ Sample data loaded successfully!"
      puts "   Categories: #{Category.count}"
      puts "   Projects: #{Project.count}"
      puts ""
      puts "Try: ./toolbox stats"
      puts "Or:  ./toolbox generate --output=demo.md"
    end
  end
end