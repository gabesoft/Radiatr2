PROJECT_PATH =
  File.expand_path( File.join( File.dirname(__FILE__), ".") )

ENV["ENVIRONMENT"] ||= "development"

require 'rubygems'
require "bundler"
Bundler.setup( :default, ENV["ENVIRONMENT"].to_sym )
puts "Bundler loaded unlocked environment: #{ENV["ENVIRONMENT"]}" if $DEBUG

require 'json'
require 'yaml'
require 'net/http'
require 'sinatra'

$LOAD_PATH.unshift( "#{PROJECT_PATH}")
$LOAD_PATH.unshift("#{PROJECT_PATH}/lib")

%w[lib].each do |path|
  Dir["#{PROJECT_PATH}/#{path}/**/*.rb"   ].each { |lib| require lib }
end

require 'radiatr'
