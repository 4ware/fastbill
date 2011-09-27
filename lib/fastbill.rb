require "fastbill/version"

module Fastbill
  attr_reader :email, :api_key
  class << self
    def new(email, api_key)
      @email = email
      @api_key = api_key
      self
    end
    def test
      puts @email
    end
  end
end
