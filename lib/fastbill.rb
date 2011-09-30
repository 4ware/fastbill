require 'httparty'
require 'crack/xml'
require "fastbill/version"
require "fastbill/customer"

module Fastbill
  attr_reader :auth
  class << self
    include HTTParty
    base_uri 'https://portal.fastbill.com'
    def new(email, api_key)
      @auth = {:username => email, :password => api_key}
      self
    end
    def customers
      c = Customer.new(@auth).customers
      unless c.body.nil?
        r = Crack::XML.parse c.body
        r['FBAPI']['RESPONSE']
      end
    end
    def customer(id)
      Customer.new(@auth).find(id)
    end

    def fetch(req)
      options = { :query => req, :basic_auth => @auth }
      self.class.post('/api/0.1/api.php', options)
    end
  end
end