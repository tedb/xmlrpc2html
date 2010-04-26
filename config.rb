# This uses the DSL for the Xmlrpc2Html application

# This will be the overall <title> and <h1> for the Web interface
title 'Web Service Testing'

# Target is at a certain URL
target 'http://localhost:9999/XMLRPC1' do
  
  # Title of the target will be an <h2> and shown in the navbar
  title 'Fake user creation'
  
  # URL path to this target -- must be unique
  user_path '/user_creation'
  
  # One or more XML-RPC methods are specified by name
  rpc_method 'createuser' do
    
    # Method title shown in navbar, nested under the target title
    title 'Create user'
    
    # HTML input form will be generated to prompt for one name/value pair, with key :username of datatype String
    input_template :username => String
    
    # HTML form will also have a button labeled "Test: should return success".
    # Button will execute Web service with the "input" data shown here,
    # and compare the result against the "expect" data
    test 'should return success' do
      input :username => 'xmlrpctest9999'
      expect :status => 'SUCCESS'
    end
    
    test 'should return failure' do
      input :username => "invalid!^%$#^username"
      expect :status => 'FAILURE'
    end
    
    test 'should raise exception' do
      input nil
      expect XMLRPC::FaultException
    end
  end
  
  rpc_method "deleteuser" do
    title "Delete user"
    # Boolean inputs can be either TrueClass or FalseClass, which will show True/False radio buttons
    input_template :username => String, :confirm => TrueClass
  end
end

target 'http://localhost:9999/XMLRPC2' do
  title 'Math'
  
  user_path '/add'
      
  rpc_method :add do
    title 'Add Numbers'
    
    # HTML form will prompt for an array of two integers, unlabeled
    # Ideally all fields would be labeled but we are trying to stay close to the
    # XML-RPC method's profile
    input_template [Integer, Integer]
    
    test 'Add' do
      # Notice that the test input reflects the same datastructure as input_template
      input [1, 2]
      
      # We don't specify in advance what structure the method is going to return.
      # The method-testing implementation will do e.g.  response.is_a?(expect.class)
      expect 3
    end
  end
end
