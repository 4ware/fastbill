require "fastbill/version"

module Fastbill
  attr_reader :email, :api_key
  class << self
    def authenticate(email, api_key)
      @email = email
      @api_key = api_key
      self
    end
  end
end
