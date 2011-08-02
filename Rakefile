require "rake"

require 'spec/rake/spectask'

require File.expand_path( File.join( File.dirname( __FILE__ ), 'boot' ) )

SPEC_DIR = "#{PROJECT_PATH}/spec"
desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new do |task|
  task.spec_opts = ['--options', "#{SPEC_DIR}/spec.opts"]
  task.pattern   = "spec/**/*.rb"  
end

desc "Run radiatr server"
task :run do
  Server.run!
end

task :default => :run