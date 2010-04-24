#!/usr/bin/spec

require File.join(File.dirname(__FILE__), '..', 'lib', "xmlrpc2html_libs.rb")

class TestConfigDSL < Test::Unit::TestCase
  #def setup
  
  #end
  
  def test_dsl_1
    config_data = Xmlrpc2Html::Config.config do
      title "hi"
      target 'http://foo' do
        title "t1"
        rpc_method "a" do
          title "m1"
        end
      end
    end
    
    assert config_data.is_a?(Xmlrpc2Html::ConfigData), "config should be a ConfigData"
  end
end
