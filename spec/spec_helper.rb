require 'rubygems'
require 'bundler/setup'

require 'fastbill'
require 'vcr'

MY_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/support/fastbill.yml")

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end
