require File.join(File.dirname(__FILE__), 'lib', "xmlrpc2html_libs.rb")

config = Xmlrpc2Html::Config.config File.dirname(__FILE__) + '/config.rb'

puts "Config: " + config.inspect

#Xmlrpc2Html::WebGenerate.new.app(config)
