require 'bundler/setup'
require 'sinatra'
require_relative 'lib/java_compat.rb'

error do
  e = env['sinatra.error']
  url = request.url
  ip = request.ip
  backtrace = "Application error\n#{e}\n#{e.backtrace.join("\n")}"
  log.info "failure on #{url}"
  log.info backtrace
  halt 500
end
