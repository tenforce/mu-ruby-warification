require 'rjack-slf4j'
require 'rjack-slf4j/simple'
require 'sinatra'
require 'sparql/client'
require 'json'
require 'rdf/vocab'
require 'bson'
require_relative 'sinatra_template/helpers.rb'

configure do
  set :graph, ENV['MU_APPLICATION_GRAPH']
  set :sparql_client, SPARQL::Client.new(ENV['MU_SPARQL_ENDPOINT'])

  ###
  # Logging
  ###
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
require_relative "ext/web.rb"
