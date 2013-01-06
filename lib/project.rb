require 'json'
require 'capistrano/cli'

class Project
  def initialize(path)
    @path = path
  end

  def self.all(root_path)
    projects = []
    Dir["#{root_path}/*/"].each do |dir|
      projects << Project.new(dir)
    end
    projects
  end

  def name
    File.basename @path
  end

  def to_json(options = nil)
    { name: name }.to_json
  end

  def cap(args)
    FileUtils.chdir @path do
      Capistrano::CLI.parse(args).execute!
    end
  end
end
