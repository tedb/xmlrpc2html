require 'logger'
require 'rubygems'
require 'sinatra/base'
require 'validatable'
require 'haml'
require 'xmlrpc/client'

$LOAD_PATH.unshift File.dirname(__FILE__)
require 'helpers.rb'
require 'web_generate.rb'
require 'config_dsl.rb'
