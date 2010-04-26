module Xmlrpc2Html
  # The purpose of Xmlrpc2Html::ConfigDSL.config is to return a ConfigData instance
  class ConfigData < Struct.new :title, :targets
    class Target < Struct.new :title, :rpc_methods, :url, :user_path
      class RpcMethod < Struct.new :title, :tests, :method_name, :options, :input_template
        class Test < Struct.new :title, :input, :expect
        end
      end
    end
  end
  
  class ConfigDSLBase
    @@LOGGER = Logger.new(STDERR)
    @@LOGGER.level = Logger::DEBUG
    def log; @@LOGGER; end
    def self.log; @@LOGGER; end
    
    # everything can have a title
    def title title_name
      @config_data.title = title_name
    end
  end
  
  class ConfigDSL < ConfigDSLBase
    # Takes a config file name and/or a block,
    # both of which must use our config DSL
    def self.config(filename = nil, &block)
      thisconfig = self.new
      thisconfig.instance_eval(File.read(filename), filename) if filename
      thisconfig.instance_eval(&block) if block
      return thisconfig.config_data
    end

    attr_accessor :config_data
    
    def initialize
      @config_data = ConfigData.new
    end
        
    def target url, &block
      log.debug "ConfigDSL#target '#{url}'"
      new_target = Target.new url
      new_target.instance_eval(&block)
      @config_data.targets ||= []
      @config_data.targets << new_target.config_data
    end
  
    class Target < ConfigDSLBase
      attr_accessor :config_data
      def initialize url
        @config_data = ConfigData::Target.new
        @config_data.url = url
      end
      
      def user_path user_path
        log.debug "Target#user_path '#{user_path}'"
        @config_data.user_path = user_path
      end
            
      def rpc_method method_name, &block
        log.debug "Target#rpc_method '#{method_name}'"
        new_method = RpcMethod.new method_name
        new_method.instance_eval(&block)
        log.debug "Got new method: #{new_method.inspect}"
        @config_data.rpc_methods ||= []
        @config_data.rpc_methods << new_method.config_data
      end
    
      class RpcMethod < ConfigDSLBase
        attr_accessor :config_data
        def initialize method_name
          @config_data = ConfigData::Target::RpcMethod.new
          @config_data.method_name = method_name
        end
        
        def input_template template
          log.debug "RpcMethod#input_template '#{template}'"
          @config_data.input_template = template
        end
        
        def test test_name, &block
          log.debug "RpcMethod#test '#{test_name}'"
          new_test = Test.new test_name
          new_test.instance_eval(&block)
          log.debug "Got new test: #{new_test.inspect}"
          @config_data.tests ||= []
          @config_data.tests << new_test.config_data
        end
        
        class Test < ConfigDSLBase
          attr_accessor :config_data
          def initialize test_name
            @config_data = ConfigData::Target::RpcMethod::Test.new
            @config_data.title = test_name
          end
          
          def input input
            log.debug "Test#input '#{input}'"
            @config_data.input = input
          end
          
          def expect expect
            log.debug "Test#expect '#{expect}'"
            @config_data.expect = expect
          end
        end
      end
    end
  end
end