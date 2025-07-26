require 'thor'
require 'active_record'
require 'sqlite3'
require 'erb'
require 'json'

require_relative 'toolbox/database'
require_relative 'toolbox/cli'
require_relative 'toolbox/generator'
require_relative 'toolbox/models/category'
require_relative 'toolbox/models/project'
require_relative 'toolbox/models/metadata'

module Toolbox
  VERSION = "1.0.0"
  
  def self.root
    File.dirname(__dir__)
  end
  
  def self.database_path
    File.join(root, 'toolbox.db')
  end
end