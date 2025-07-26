module Toolbox
  class Generator
    def initialize(template_path = nil)
      @template_path = template_path || default_template_path
    end
    
    def generate
      template = File.read(@template_path)
      erb = ERB.new(template)
      
      erb.result(binding)
    end
    
    private
    
    def default_template_path
      File.join(Toolbox.root, 'templates', 'readme.md.erb')
    end
    
    def categories
      @categories ||= Category.ordered.includes(:projects)
    end
    
    def metadata
      @metadata ||= {
        'title' => Metadata.get('title') || 'AI Engineering Toolbox',
        'description' => Metadata.get('description') || 'A list of open-source tools and resources for AI Engineering'
      }
    end
  end
end