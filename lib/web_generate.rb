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
    
    set :public, File.dirname(__FILE__) + '/../public'
    set :views, File.dirname(__FILE__) + '/../views'
    
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
        target.rpc_methods.each do |rpc_method|
          url = url_for_target_method(target, rpc_method)
          warn "Generating target path for GET and POST: #{url}"
          
          # register a URL handler for rendering the blank form
          get url do
            #body = render_form(target, rpc_method, action_url)
            #body = erb(:xmlrpc_form, {}, {:target => target, :rpc_method => rpc_method, :action_url => url })
            body = haml(:xmlrpc_form, :locals => {:target => target, :rpc_method => rpc_method, :action_url => url })
            layout(@@config_data, body)
          end
          
          # register a URL handler for taking the form input, running it, showing the results, and
          # then rendering a pre-filled version of the GET form
          post url do
            #body = render_form(target, rpc_method, action_url) + params().inspect
            body = haml(:xmlrpc_form, :locals => {:target => target, :rpc_method => rpc_method, :action_url => url })
            layout(@@config_data, body + params().inspect)
          end
        end
      end
    end
    
    def target_for_url url
      
    end
    
    def input_template_form_fragment input_template
      template_class = input_template.is_a?(Class) ? input_template : input_template.class
      template_name = "form_datatype_" + template_class.to_s.downcase
      warn "template name: #{template_name}"
      return haml(template_name.to_sym, :locals => {:input_template => input_template})
    end
  end
end