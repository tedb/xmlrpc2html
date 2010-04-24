module Xmlrpc2Html
  # The purpose of Xmlrpc2Html::ConfigDSL.config is to return a ConfigData instance
  class ConfigData < Struct.new :title, :targets
    def initialize
      targets = []
    end
    
    class Target < Struct.new :rpc_methods, :url
      def initialize
        rpc_methods = []
      end
      
      class RpcMethod < Struct.new :tests, :method_name, :options, :input_template
        def initialize
          tests = []
        end
        
        class Test < Struct.new :input, :expect
        end
      end
    end
  end
  
  class ConfigDSLBase
    @@LOGGER = Logger.new(STDERR)
    @@LOGGER.level = Logger::DEBUG
    def log
      @@LOGGER
    end
    
    def title display_data = nil
      @display = display_data unless display_data.nil?
      return @display
    end
  end
  
  class ConfigDSL < ConfigDSLBase
    attr_accessor :targets
    def initialize; @display, @targets = '', []; end
    
    # Takes a config file name and/or a block,
    # both of which should use our config DSL
    def self.config(filename = nil, &block)
      thisconfig = self.new
      thisconfig.instance_eval(File.read(filename), filename) if filename
      thisconfig.instance_eval(&block) if block
      thisconfig
    end
    
    def target url, options = {}, &block
      log.debug "ConfigDSL#target '#{url}', #{options.inspect}"
      new_target = Target.new :url => url, :options => options
      new_target.instance_eval(&block)
      self.targets << new_target
    end
  
    class Target < ConfigDSLBase
      attr_accessor :rpc_methods, :url, :options
      def initialize(args)
        @rpc_methods, @url, @options, @display = [], '', {}, ''
      end
      
      def rpc_method method_name, options = {}, &block
        log.debug "Target#rpc_method '#{method_name}', #{options.inspect}"
        new_method = RpcMethod.new :method_name => method_name,
                                   :options => options
        new_method.instance_eval(&block)
        puts "Got new method: #{new_method.inspect}"
        self.rpc_methods << new_method
      end
    
      class RpcMethod < ConfigDSLBase
        attr_accessor :tests, :method_name, :options, :input_template
        def initialize(args)
          @tests, @method_name, @options, @display, @input_template = [], '', {}, '', nil
        end

        def input_template template = nil
          return @input_template if template.nil?
          log.debug "RpcMethod#input_template '#{template}'"
          self.input_template = template
        end
  
        def test test_name, &block
          log.debug "RpcMethod#test '#{test_name}'"
          new_test = Test.new
          new_test.instance_eval(&block)
          self.tests << new_test
        end
    
        class Test < ConfigDSLBase
          attr_accessor :input, :expect
          def initialize
            @display = ''
          end

          def input input = nil
            return @input if input.nil?
            log.debug "Test#input '#{input}'"
            self.input = input
          end
  
          def expect expect = nil
            return @expect if expect.nil?
            log.debug "Test#expect '#{expect}'"
            self.expect = expect
          end
        end
      end
    end
  end
end