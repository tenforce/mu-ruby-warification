require 'rjack-slf4j'
require 'rjack-logback'
require 'sinatra'
require 'sparql/client'
require 'json'
require 'rdf/vocab'
require 'bson'
require 'psych'
require_relative 'sinatra_template/helpers.rb'
require_relative 'lib/escape_helpers.rb'

include RJack
configure do
  java_import 'java.lang.System'

  config_dir = System.get_property('CONFIG_DIR_VAR')
  config = Psych.load_file("#{config_dir}/config.yml")

  set :graph, config['MU_APPLICATION_GRAPH']
  if config['MU_SPARQL_AUTH']
   set :sparql_client, SPARQL::Client.new(config['MU_SPARQL_ENDPOINT'], headers: {"Authorization" => "Basic #{MU_SPARQL_AUTH}"})
  else
    set :sparql_client, SPARQL::Client.new(config['MU_SPARQL_ENDPOINT'])
  end

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
MU_EXT = RDF::Vocabulary.new(MU.to_uri.to_s + 'ext/')

SERVICE_RESOURCE_BASE = 'http://mu.semte.ch/services/'


###
# Helpers
###

helpers SinatraTemplate::Helpers
require_relative "ext/#{app_file}"
