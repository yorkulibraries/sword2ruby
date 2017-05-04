require 'atom/http'

module Sword2Ruby

  #The Connection class inherits from the Atom::HTTP class to ensure authentication credentials are used on Sword operations.
  #
  #Please see the {atom-tools documentation}[http://rdoc.info/github/bct/atom-tools/master/frames] for a complete list of attributes and methods (including post, get, put, delete etc).
  class Connection < ::Atom::HTTP

    #The Sword2Ruby::User credentials object this connection is using, or nil for anonymous communication
    attr_reader :user_credentials
    
    #Boolean value indicating whether authentication is used
    attr_reader :use_authentication

    #Creates a new Connection object
    #===Parameters
    #user_credentials:: (optional) a Sword2Ruby::User object with the username and password
    def initialize(user_credentials = nil)
      unless user_credentials.nil?
        Utility.check_argument_class('user_credentials', user_credentials, User)
      end
      @user_credentials = user_credentials
      @use_authentication = @user_credentials && @user_credentials.username && @user_credentials.password

      super() #initialize the base (Atom::HTTP) class
      
      if @use_authentication
        self.user = @user_credentials.username
        self.pass = @user_credentials.password
        self.always_auth = :basic
      end
      
    end #initialize

    def get(url, headers = {})
      headers.merge!({ 'On-Behalf-Of' => @user_credentials.on_behalf_of}) if @user_credentials.on_behalf_of
      super(url, headers)
    end

    def post(url, body, headers = {})
      headers.merge!({ 'On-Behalf-Of' => @user_credentials.on_behalf_of}) if @user_credentials.on_behalf_of
      super(url, body, headers)
    end

    def put(url, body, headers = {})
      headers.merge!({ 'On-Behalf-Of' => @user_credentials.on_behalf_of}) if @user_credentials.on_behalf_of
      super(url, body, headers)
    end    

    def delete(url, body = nil, headers = {})
      headers.merge!({ 'On-Behalf-Of' => @user_credentials.on_behalf_of}) if @user_credentials.on_behalf_of
      super(url, body, headers)
    end
  end  #class
end #module