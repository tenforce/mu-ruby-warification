require 'rjack-slf4j'
require 'rjack-logback'
require 'sinatra'
require 'sparql/client'
require 'json'
require 'rdf/vocab'
require 'bson'
require 'psych'
require_relative 'sinatra_template/helpers.rb'

include RJack
configure do
  java_import 'java.lang.System'

  config_dir = System.get_property('CONFIG_DIR_VAR')
  config = Psych.load_file("#{config_dir}/config.yml")

  set :graph, config['MU_APPLICATION_GRAPH']
  set :sparql_client, SPARQL::Client.new(config['MU_SPARQL_ENDPOINT'])

  Logback.configure do
    Logback.load_xml_config("#{config_dir}/logback.xml")
  end
  log = RJack::SLF4J[ "mu.semtech.logger" ]  
  set :log, log
end

###
# Vocabularies
###

include RDF
MU = RDF::Vocabulary.new('http://mu.semte.ch/vocabularies/')
MU_CORE = RDF::Vocabulary.new(MU.to_uri.to_s + 'core/')

###
# Helpers
###

helpers SinatraTemplate::Helpers
require_relative "ext/#{app_file}"
