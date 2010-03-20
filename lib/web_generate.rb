module Xmlrpc2Html
  class WebGenerate
    def app(app)
      raise ArgumentError "app must be Xmlrpc2Html::Setup" unless app.is_a?(Xmlrpc2Html::Setup)
      
      get '/' do
        layout(app, app.inspect)
      end
    end
  end
end