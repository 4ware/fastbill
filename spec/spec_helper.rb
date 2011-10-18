require 'rubygems'
require 'bundler/setup'

require 'fastbill' # and any other gems you need

MY_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/support/fastbill.yml")

RSpec.configure do |config|
  # some (optional) config here
end