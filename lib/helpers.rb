module Xmlrpc2Html
  module Helpers
    # Executed from inside Xmlrpc2Html::WebApp class definition
    
    module ClassMethods
      def url_for_target_method(target, method)
        "#{target.user_path}/#{method.method_name}"
      end
    end
    
    include ClassMethods
    
    def navbar(app)
      navbar = ''
      app.targets.sort_by {|t| t.title }.each_with_index do |target, target_i|
        navbar << '<h3>%s</h3>' % target.title
        navbar << '<ul>'
        target.rpc_methods.sort_by {|m| m.title }.each_with_index do |method, method_i|
          navbar << '<li><a href="%s">%s</a></li>' % [url_for_target_method(target, method), method.title]
        end
        navbar << '</ul>'
      end
      navbar
    end
  
    def layout(app, body)
      raise ArgumentError "app must be Xmlrpc2Html::ConfigData" unless app.is_a?(Xmlrpc2Html::ConfigData)
      return <<-_HTML_
      <html>
        <head>
          <title>xmlrpc2html</title>
          <link href="/style.css" rel="stylesheet" type="text/css" />
        </head>
        <body>
          <div id="navbar">
            #{navbar(app)}
          </div>
          <div id="content">
            #{body}
          </div>
        </body>
      </html>
      _HTML_
    end
  end
end