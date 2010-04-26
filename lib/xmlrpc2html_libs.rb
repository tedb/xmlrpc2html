require 'logger'
require 'rubygems'
require 'sinatra'
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'helpers.rb'
require 'web_generate.rb'
require 'config_dsl.rb'
require 'xmlrpc/client'
