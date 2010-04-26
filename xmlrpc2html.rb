require File.join(File.dirname(__FILE__), 'lib', "xmlrpc2html_libs.rb")

config = Xmlrpc2Html::ConfigDSL.config File.dirname(__FILE__) + '/config.rb'

puts "Config: " + config.inspect

#Xmlrpc2Html::WebGenerate.new(config)

Xmlrpc2Html::WebApp.config_data = config
Xmlrpc2Html::WebApp.build_routes!
Xmlrpc2Html::WebApp.run! :host => 'localhost', :port => 9090
#run Sinatra::Base

