require "rake"

require 'spec/rake/spectask'

require File.expand_path( File.join( File.dirname( __FILE__ ), 'boot' ) )

Radiatr.run!
