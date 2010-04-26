#!/usr/bin/spec

require File.join(File.dirname(__FILE__), '..', 'lib', "xmlrpc2html_libs.rb")

Xmlrpc2Html::ConfigDSLBase.log.level = Logger::WARN

describe Xmlrpc2Html::ConfigDSL, "#config" do
  it "should be a ConfigData object" do
    config_data = Xmlrpc2Html::ConfigDSL.config do; end  # no file and no block specified
    
    config_data.should be_a Xmlrpc2Html::ConfigData
  end

  it "should have an application title" do
    config_data = Xmlrpc2Html::ConfigDSL.config do
      title "hi"
    end
    
    config_data.title.should == "hi"
  end

  it "should have an application title and 2 targets" do
    config_data = Xmlrpc2Html::ConfigDSL.config do
      title "hey"
      target 'http://foo' do; end
      target 'http://bar' do; end
    end
    
    config_data.title.should == "hey"
    config_data.targets[0].url.should == 'http://foo'
    config_data.targets[1].url.should == 'http://bar'
  end
  
  it "should have a target with rpc_method 'add' that has title 'Add'" do
    config_data = Xmlrpc2Html::ConfigDSL.config do
      target 'http://foo' do
        rpc_method "add" do
          title "Add"
        end
      end
    end
    
    config_data.targets.first.rpc_methods.first.method_name.should == 'add'
    config_data.targets.first.rpc_methods.first.title.should == 'Add'
  end
end
