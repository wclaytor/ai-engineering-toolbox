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
  end
end