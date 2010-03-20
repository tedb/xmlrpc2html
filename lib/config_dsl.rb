require 'ostruct'
module Xmlrpc2Html
  module ConfigMixin
    def display display_data = nil
      @display = display_data unless display_data.nil?
      return @display
    end
  end
  
  class Config < OpenStruct
    include Xmlrpc2Html::ConfigMixin
    attr_accessor :targets
    def initialize; @display, @targets = '', []; end
    
    def self.config(&block)
      app = self.new
      app.instance_eval(&block)
      app
    end
        
    def target url, options = {}, &block
      new_target = Target.new :url => url, :options => options
      new_target.instance_eval(&block)
      self.targets << new_target
    end
  
    class Target < OpenStruct
      include Xmlrpc2Html::ConfigMixin
      attr_accessor :xmlrpc_methods, :url, :options
      def initialize(args)
        @xmlrpc_methods, @url, @options, @display = [], '', {}, ''
        super
      end
      
      def method method_name, options = {}, &block
        new_method = XmlrpcMethod.new :method_name => method_name,
                                      :options => options
        new_method.instance_eval(&block)
        puts "Got new method: #{new_method.inspect}"
        self.xmlrpc_methods << new_method
      end
    
      class XmlrpcMethod < OpenStruct
        include Xmlrpc2Html::ConfigMixin
        attr_accessor :tests, :method_name, :options
        def initialize(args)
          @tests, @method_name, @options, @display = [], '', {}, ''
          super
        end

        def input_template template
          self.input_template = template
        end
  
        def test test_name, &block
          new_test = Test.new
          new_test.instance_eval(&block)
          self.tests << new_test
        end
    
        class Test < OpenStruct
          include Xmlrpc2Html::ConfigMixin
          attr_accessor :input, :expect
          def initialize
            @display = ''
            super
          end

          def input input
            self.input = input
          end
  
          def expect expect
            self.expect = expect
          end
        end
      end
    end
  end
end