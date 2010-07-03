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
    
    get '/style.css' do
      File.read 'public/style.css'
    end
    
    def self.build_routes!
      @@config_data.targets.each do |target|
        target.rpc_methods.each do |method|
          url = url_for_target_method(target, method)
          warn "Generating target path: #{url}"
          get url do
            #navbar(@@config_data) + "<hr>" + target.title
            body = render_form(target)
            layout(@@config_data, body)
          end
          
          post url do
            body = render_form(target) + params().inspect
            layout(@@config_data, body)
          end
        end
      end
    end
    
    def target_for_url url
      
    end
    
    def render_form target
      target.inspect + <<-__HTML__
      <hr>
      <form name="user_creation__creatuser" action="/user_creation/createuser" method="POST">
      username: <input type="text" name="username"><br>
      <input type="submit" value="Execute">
      <input type="reset" value="Clear Form">

      <input type="button" onclick="document.user_creation__creatuser.username.value = 'xmlrpctest9999'; document.user_creation__creatuser.username.disabled = 0" value="Test: should return success"><br>

      <input type="button" onclick="document.user_creation__creatuser.username.value = 'invalid!^%$#^username'; document.user_creation__creatuser.username.disabled = 0" value="Test: should return failures"><br>

      <input type="button" onclick="document.user_creation__creatuser.username.disabled = 1" value="Test: should raise exception"><br>

      </form>
      __HTML__
    end
  end
end