require 'rubygems'
require 'sinatra'

configure do
  set :war, File.dirname(__FILE__)
end

require_relative 'app/before.rb'
Dir.glob(File.join('app', 'before.d', '*.rb')) do |src|
  require_relative src
end
require_relative 'app/web.rb'
require_relative 'app/after.rb'
Dir.glob(File.join('app', 'after.d', '*.rb')) do |src|
  require_relative src
end

run Sinatra::Application
