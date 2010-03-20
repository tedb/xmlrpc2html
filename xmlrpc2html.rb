require 'rubygems'
require 'sinatra'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'helpers.rb'
require 'web_generate.rb'
require 'config_dsl.rb'

config = Xmlrpc2Html::Config.config do
  # Tried using load here but it didn't seem to do the right thing
  eval File.read File.dirname(__FILE__) + '/config.rb'
end

puts "Config: " + config.inspect

Xmlrpc2Html::WebGenerate.new.app(config)
