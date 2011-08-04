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
  Radiatr.run!
end

task :default => :run

require 'coffee-script'

namespace :js do
  desc "compile coffee-scripts from ./coffee to ./public/javascripts"
  task :brew do
    source = "#{File.dirname(__FILE__)}/coffee/"
    javascripts = "#{File.dirname(__FILE__)}/public/javascripts/"
    
    Dir.foreach(source) do |cf|
      unless cf == '.' || cf == '..' 
        js = CoffeeScript.compile File.read("#{source}#{cf}") 
        open "#{javascripts}#{cf.gsub('.coffee', '.js')}", 'w' do |f|
          f.puts js
        end 
      end 
    end
  end
end