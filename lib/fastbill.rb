require 'httparty'
require 'crack/xml'
require "fastbill/version"
require "fastbill/customer"
require "fastbill/invoice"
require "fastbill/invoice_item"
require "fastbill/invoice_vat_item"
require "fastbill/recurring"

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
    end
    def customer_get(id)
      Customer.new(@auth).get(id)
    end
    def invoice
      Invoice.new(@auth)
    end
    def recurring
      Recurring.new(@auth)
    end
  end
end