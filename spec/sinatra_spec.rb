#!/usr/bin/spec

require File.join(File.dirname(__FILE__), '..', 'lib', "xmlrpc2html_libs.rb")
require "rack/test"

Xmlrpc2Html::ConfigDSLBase.log.level = Logger::WARN

describe Xmlrpc2Html::WebApp, " Web requests" do
  include Rack::Test::Methods
  
  def app
    config = Xmlrpc2Html::ConfigDSL.config File.join(File.dirname(__FILE__), '..', 'config.rb')

    Xmlrpc2Html::WebApp.config_data = config
    Xmlrpc2Html::WebApp.build_routes!
    return Xmlrpc2Html::WebApp
  end
  
  it "should show navbar on index" do
    get '/'
    last_response.body.should =~ /navbar/
  end

  #it "should be a ConfigData object" do
  #  config_data = Xmlrpc2Html::ConfigDSL.config do; end  # no file and no block specified
  #  
  #  config_data.should be_a Xmlrpc2Html::ConfigData
  #end
  #
  #it "should have an application title" do
  #  config_data = Xmlrpc2Html::ConfigDSL.config do
  #    title "hi"
  #  end
  #  
  #  config_data.title.should == "hi"
  #end
  #
  #it "should have an application title and 2 targets" do
  #  config_data = Xmlrpc2Html::ConfigDSL.config do
  #    title "hey"
  #    target 'http://foo' do; end
  #    target 'http://bar' do; end
  #  end
  #  
  #  config_data.title.should == "hey"
  #  config_data.targets[0].url.should == 'http://foo'
  #  config_data.targets[1].url.should == 'http://bar'
  #end
  #
  #it "should have a target with rpc_method 'add' that has title 'Add'" do
  #  config_data = Xmlrpc2Html::ConfigDSL.config do
  #    target 'http://foo' do
  #      rpc_method "add" do
  #        title "Add"
  #      end
  #    end
  #  end
  #  
  #  config_data.targets.first.rpc_methods.first.method_name.should == 'add'
  #  config_data.targets.first.rpc_methods.first.title.should == 'Add'
  #end
  #
  #it "should have a target with rpc_method that has 2 tests" do
  #  config_data = Xmlrpc2Html::ConfigDSL.config do
  #    target 'http://foo' do
  #      rpc_method "add" do
  #        test "do stuff" do
  #          input "a string"
  #          expect String
  #        end
  #        test "do more" do
  #          input Integer
  #          expect 3
  #        end
  #      end
  #    end
  #  end
  #  
  #  config_data.targets.first.rpc_methods.first.tests.first.title.should == "do stuff"
  #  config_data.targets.first.rpc_methods.first.tests.first.input.should == "a string"
  #  config_data.targets.first.rpc_methods.first.tests.first.expect.should == String
  #  
  #  config_data.targets.first.rpc_methods.first.tests.last.title.should == "do more"
  #  config_data.targets.first.rpc_methods.first.tests.last.input.should == Integer
  #  config_data.targets.first.rpc_methods.first.tests.last.expect.should == 3
  #end

end
