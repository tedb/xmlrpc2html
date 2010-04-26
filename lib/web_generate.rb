module Xmlrpc2Html
#  class WebGenerate
#    def initialize(config_data)
#      raise ArgumentError "config_data must be Xmlrpc2Html::ConfigData" unless config_data.is_a?(Xmlrpc2Html::ConfigData)
#      
#      app = WebApp.new config_data
#    end
#  end
  
  class WebApp < Sinatra::Base
    web_app_helpers
    
    set :sessions, true
    
    def self.config_data=(config_data)
      @@config_data = config_data
    end
    
    def config_data
      @@config_data
    end

    get '/' do
      #layout(config_data, config_data.inspect)
      config_data.inspect
    end
    
    def self.build_routes!
      @@config_data.targets.each_with_index do |target, i|
        warn "Generating target path: #{target.user_path}"
        get target.user_path do
          target.title
        end
      end
    end
  end
end