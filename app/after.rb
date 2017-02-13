require 'bundler/setup'
require 'rjack-slf4j'
require 'rjack-logback'
require 'sinatra'

include RJack
configure do
  RJack::Logback.configure do
    Logback.load_xml_config(File.join(settings.war, "app", "logback.xml"))
  end
  set :log, RJack::SLF4J[ "mu.semtech.logger" ]
end
