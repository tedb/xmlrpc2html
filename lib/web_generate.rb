module Xmlrpc2Html
#  class WebGenerate
#    def initialize(config_data)
#      raise ArgumentError "config_data must be Xmlrpc2Html::ConfigData" unless config_data.is_a?(Xmlrpc2Html::ConfigData)
#      
#      app = WebApp.new config_data
#    end
#  end
  
  class WebApp < Sinatra::Base
    include Xmlrpc2Html::Helpers
    extend Xmlrpc2Html::Helpers::ClassMethods
    
    set :sessions, true
    
    def self.config_data=(config_data)
      @@config_data = config_data
    end
    
    def config_data
      @@config_data
    end

    get '/' do
      #layout(config_data, config_data.inspect)
      navbar(@@config_data) + "<hr>" + config_data.inspect
    end
    
    def self.build_routes!
      @@config_data.targets.each do |target|
        target.rpc_methods.each do |method|
          url = url_for_target_method(target, method)
          warn "Generating target path: #{url}"
          get url do
            navbar(@@config_data) + "<hr>" + target.title
          end
        end
      end
    end
  end
end